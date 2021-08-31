// @dart=2.9
import 'package:ecommerce/models/cart_manager.dart';
import 'package:ecommerce/screens/address/address_screen.dart';
import 'package:ecommerce/screens/cart/components/cart_tile.dart';
import 'package:ecommerce/utils/price_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carinho de compras',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct: cartProduct))
                    .toList(),
              ),
              PriceCard(
                textButton: 'Continuar para a entrega',
                onPressed: cartManager.isCartValid? (){
                  Get.to(()=>const AddressScreen());
                }:null,
              ),
            ],
          );
        },
      ),
    );
  }
}
