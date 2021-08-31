// @dart=2.9
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:flutter/foundation.dart';

class AdminUsersManager extends ChangeNotifier {
  List<UserModel> users = []..length;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription<dynamic> _streamSubscription;

  void updateUser(UserManager userManager) {
    _streamSubscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    }else{
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _streamSubscription = firestore.collection('users').snapshots().listen((snapshots) {
      users = snapshots.docs.map((doc) => UserModel.fromDocument(doc)).toList();
      users
          .sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.nome).toList();

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
