//@dart=2.9
import 'package:ecommerce/models/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Seleccionar produto'),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {

          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index){
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first,
                fit: BoxFit.cover,),
                title: Text(product.name),
                subtitle: Text(
                    'AOA ${product.basePrice.toStringAsFixed(2)}'),
                onTap: (){
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
