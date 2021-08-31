// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart_product.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = []..length;
  UserModel user;
  num productsPrice = 0.0;


  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.get();
    items = cartSnap.docs
        .map(
            (doc) => CartProduct.fromDocument(doc)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (error) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id)
          .whenComplete(() {
        debugPrint("${cartProduct.product.name} Adicionado ao carrinho!");
      });
      _onItemUpdated();
    }
    notifyListeners();
  }


  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        _removeFromCart(cartProduct);
        i--;
        continue;
      } else {
        productsPrice += cartProduct.totalPrice;
        _updateCartProduct(cartProduct: cartProduct);
      }
    }
    notifyListeners();
  }

  void _removeFromCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete().whenComplete(() {
      debugPrint('${cartProduct.product.name} Removido do carrinho');
    });
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  Future<void> _updateCartProduct({@required CartProduct cartProduct}) async {
    if (cartProduct.id != null) {
      await user.cartReference
          .doc(cartProduct.id)
          .update(cartProduct.toCartItemMap())
          .whenComplete(
              () => debugPrint('${cartProduct.product.name} actualizado'))
          .catchError((error) => debugPrint('Erro ao actualizar $error'));
    }
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false;
      }
    }
    return true;
  }
}
