// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/section_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? []
      ..length;
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.get('name') as String,
        type = snapshot.get('type') as String,
        items = (snapshot.get("items") as List)
            .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
            .toList();

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');

  String _error;
  String get error => _error;

  set error(String value) {
    _error = error;
    notifyListeners();
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = 'Titulo inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((items) => items.clone()).toList(),
    );
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    try {
      for (final item in items) {
        final ref = await storage.refFromURL(item.image as String);
        ref.delete();
      }
    }catch(error){
     debugPrint(error.toString());
    }
  }

  Future<void> saveSection(int position) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'position': position,
    };

    if (id == null) {
      final document = await firestore.collection('home').add(data);
      id = document.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(item.image as File);
        final TaskSnapshot snapshot = await task.whenComplete(() {});
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = await storage.refFromURL(original.image as String);
          await ref.delete();
        } catch (error) {
          debugPrint(error.toString());
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((i) => i.toMap()).toList(),
    };

    await firestoreRef.update(itemsData);
  }

  @override
  String toString() {
    return 'Section{id: $id, name: $name, type: $type, item: $items}';
  }
}
