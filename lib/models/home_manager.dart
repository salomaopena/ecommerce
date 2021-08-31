// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/section.dart';
import 'package:flutter/cupertino.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadAllSections();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool editing = false;
  bool loading = false;

  final List<Section> _sections = []..length;
  List<Section> _editingSections = []..length;

  Future<void> _loadAllSections() async {
    firestore.collection('home').orderBy('position').snapshots().listen((snapshot) {
      _sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.valid()) {
        valid = false;
      }
    }
    if (!valid) return;

    loading = true;
    notifyListeners();

    int position = 0;
    for (final section in _editingSections) {
      await section.saveSection(position);
      position++;
    }

    for(final section in List.from(_sections)){
      if(!_editingSections.any((s) => s.id ==section.id)){
        section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
