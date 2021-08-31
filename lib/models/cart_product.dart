// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/item_size.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartProduct extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id;
  String productId;
  int quantity;
  String size;
  Product product;

  CartProduct.fromProduct(this.product)
      : assert(product != null),
        productId = product.id,
        quantity = 1,
        size = product.selectedSize.name;

    CartProduct.fromDocument(DocumentSnapshot snapshot)
      : assert(snapshot != null) {
    id = snapshot.id;
    productId = snapshot.get('pid') as String;
    quantity = snapshot.get('quantity') as int;
    size = snapshot.get('size') as String;

    firestore.doc('products/$productId').get().then((document) {
      product = Product.fromDocument(document);
      notifyListeners();
    });
  }

  ItemSize get itemSize {
    if (product == null) {
      return null;
    } else {
      return product.findSize(size);
    }
  }

  num get unityPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unityPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  @override
  String toString() {
    return 'CartProduct{id: $id, productId: $productId, quantity: $quantity, size: $size}';
  }

/*CartProduct.fromDocument(DocumentSnapshot snapshot) {
    if (snapshot != null) {
      id = snapshot.id;
      productId = snapshot.get('pid') as String;
      quantity = snapshot.get('quantity') as int;
      size = snapshot.get('size') as String;

      firestore.doc('products/$productId').get().then((document) {
        product = Product.fromDocument(document);
        notifyListeners();
      });
    }
  }*/
}
