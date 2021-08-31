// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/utils/firebase_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel user;
  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn {
    return user != null;
  }

  bool get adminEnabled {
    return user != null && user.admin;
  }

  Future<void> sigIn(
      {@required UserModel user,
      @required Function onFail,
      @required Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
              email: user.email, password: user.password);

      await _loadCurrentUser(firestoreUser: userCredential.user);

      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  Future<void> signUp(
      {@required UserModel userModel,
      @required Function onFail,
      @required Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: user.email, password: user.password);

      user.id = userCredential.user.uid;
      user = userModel;

      await user.saveData();

      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firestoreUser}) async {
    final User currentUser = firestoreUser ?? auth.currentUser;

    if (currentUser != null) {

      final DocumentSnapshot docUser =
          await firestore.collection("users").doc(currentUser.uid).get();
      user = UserModel.fromDocument(docUser);

      final adminDoc = await firestore.collection('admins').doc(user.id).get();
      if (adminDoc.exists) {
        user.admin = true;
      }
      notifyListeners();
    }
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  /*Future<void> _loadCurrentUser({User? user}) async {
    final User currentUser = user ?? auth.currentUser!;
    if (currentUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> docUser =
      await firestore.collection("users").doc(currentUser.uid).get();
      this.user = UserModel.fromDocument(docUser);
      debugPrint(this.user!.nome);
      notifyListeners();
    }
    //notifyListeners();
  }*/
}
