// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/item_size.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product({this.id, this.name, this.description, this.images, this.sizes}) {
    images = images ?? []
      ..length;
    sizes = sizes ?? []
      ..length;
  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  List<dynamic> newImages;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => firebaseStorage.ref().child('products').child(id);

  Product.fromDocument(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        name = snapshot.get("name") as String,
        description = snapshot.get("description") as String,
        images = List<String>.from(snapshot.get("images") as List<dynamic>),
        sizes = (snapshot.get("sizes") as List<dynamic>)
            .map((size) => ItemSize.fromMap(size as Map<String, dynamic>))
            .toList();

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> saveProduct() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      firestoreRef.update(data);
    }

    final List<String> updateImage = []..length;

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImage.add(newImage as String);
      } else {
        final UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task.whenComplete(() {});
        final String url = await snapshot.ref.getDownloadURL();
        updateImage.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref = await firebaseStorage.refFromURL(image);
          await ref.delete();
        } catch (error) {
          debugPrint('Erro ao excluir imagem $image');
        }
      }
    }
    await firestoreRef.update({'images': updateImage});
    images = updateImage;
    loading = false;
  }

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((size) => size.name == name);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Product clone() {
    return Product(
        id: id,
        name: name,
        description: description,
        images: List.from(images),
        sizes: sizes.map((size) => size.clone()).toList());
  }

/*Product.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get("name") as String;
    description = snapshot.get("description") as String;
    images = List<String>.from(snapshot.get("images") as List<dynamic>);
    sizes = (snapshot.get("sizes") as List<dynamic>)
        .map((size) => ItemSize.fromMap(size as Map<String, dynamic>))
        .toList();
  }*/
}
