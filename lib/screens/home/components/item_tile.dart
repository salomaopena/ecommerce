// @dart=2.9
import 'dart:io';

import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/products_manager.dart';
import 'package:ecommerce/models/section.dart';
import 'package:ecommerce/models/section_item.dart';
import 'package:ecommerce/screens/product_detail/product_datail_screen.dart';
import 'package:ecommerce/screens/select_product/select_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({@required this.item});

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProdcutById(item.product);
          if (product != null) {
            Get.to(() => ProductDetailScreen(product: product));
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final product = context
                        .read<ProductManager>()
                        .findProdcutById(item.product);

                    return AlertDialog(
                      title: const Text('Editar item'),
                      content: product != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images.first),
                              title: Text(product.name),
                              subtitle: Text(
                                  'AOA ${product.basePrice.toStringAsFixed(2)}'),
                            )
                          : null,
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<Section>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Excluir',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (product != null) {
                              item.product == null;
                            } else {
                              final Product product = await Get.to(
                                  () => const SelectProductScreen()) as Product;
                              item.product = product?.id;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            product != null ? 'Desvincular' : 'Vincular',
                          ),
                        )
                      ],
                    );
                  });
            }
          : null,
      child: Card(
        child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.image as String,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  item.image as File,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
