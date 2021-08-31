// @dart=2.9
import 'package:ecommerce/models/item_size.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({@required this.size});
  final ItemSize size;
  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;
    Color color;
    if (!size.hasStock) {
      color = Colors.red.withAlpha(50);
    } else if (selected) {
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: (){
        if(size.hasStock){
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: color,
        )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )),
            Flexible(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Text(
                'AOA ${size.price.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
