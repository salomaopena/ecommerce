// @dart=2.9
import 'package:ecommerce/models/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({this.textButton, this.onPressed});
  final String textButton;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productPrice = cartManager.productsPrice;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo do pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text(
                  'AOA ${productPrice.toStringAsFixed(2)}',
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'AOA ${productPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(16),
                  enableFeedback: true,
                  onSurface: Colors.grey,
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: onPressed,
                child: Text(
                  textButton,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
    );
  }
}
