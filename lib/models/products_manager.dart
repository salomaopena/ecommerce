// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/foundation.dart';

class ProductManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = []..length;
  String _search = '';
  String get search => _search;

  ProductManager() {
    _loadAllProducts();
  }
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = []..length;
    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((produto) =>
          produto.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot querySnapshotProducts =
        await firestore.collection("products").get();
    allProducts = querySnapshotProducts.docs
        .map((doc) => Product.fromDocument(doc))
        .toList();
    notifyListeners();
  }

  Product findProdcutById(String id){
    try {
      return allProducts.firstWhere((p) => p.id == id);
    }catch(error){
     debugPrint('$error');
     return null;
    }
  }

  void update(Product product){
    allProducts.removeWhere((p) => p.id ==product.id);
    allProducts.add(product);
    notifyListeners();
  }
}
