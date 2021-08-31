// @dart=2.9
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ecommerce/models/cart_manager.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/edit_product/edit_product_screen.dart';
import 'package:ecommerce/screens/product_detail/components/size_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

@immutable
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            product.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  onPressed: () {
                    Get.to(()=>EditProductScreen(product));
                  },
                  icon: const Icon(Icons.edit),
                );
              }else{
                return Container();
              }
            })
          ],
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AOA ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(product.description,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((size) {
                      return SizeWidget(size: size);
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.all(16),
                          enableFeedback: true,
                          onSurface: Colors.grey,
                          textStyle: const TextStyle(
                            fontSize: 17,
                          ),
                          backgroundColor: primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                        ),
                        onPressed: product.selectedSize != null
                            ? () {
                                if (userManager.isLoggedIn) {
                                  context
                                      .read<CartManager>()
                                      .addToCart(product);
                                  Navigator.of(context).pushNamed('/cart');
                                  //Get.to(() => CartScreen());
                                } else {
                                  Navigator.of(context).pushNamed('/login');
                                }
                              }
                            : null,
                        child: !userManager.loading
                            ? Text(userManager.isLoggedIn
                                ? 'Adicionar ao carrinho'
                                : 'Entre para comprar')
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                      );
                    }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
