// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String nome;
  String email;
  String password;
  String password2;
  bool admin = false;

  UserModel({this.email, this.password, this.nome, this.id});

  UserModel.fromDocument(DocumentSnapshot doc)
      : assert(doc != null),
        id = doc.id,
        nome = doc.get('name') as String,
        email = doc.get('email') as String;

  /*factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      id: doc.id,
      nome: doc.data()!['name'] as String,
      email: doc.data()!['email'] as String
    );
  }*/

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc("users/$id");

  CollectionReference get cartReference => firestoreRef.collection("cart");

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
