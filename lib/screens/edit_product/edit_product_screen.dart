//@dart=2.9
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/products_manager.dart';
import 'package:ecommerce/screens/edit_product/components/images_forms.dart';
import 'package:ecommerce/screens/edit_product/components/sizes_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            editing ? 'Editar Produto' : 'Criar Produto',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForms(product: product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Produto',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Informe um produto válido!';
                        }
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Text(
                      'A partir de ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AOA ${product.basePrice?.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      style: const TextStyle(fontSize: 14),
                      validator: (description) {
                        if (description.isEmpty) {
                          return 'Informe uma descrição válida!';
                        }
                        return null;
                      },
                      onSaved: (description) =>
                          product.description = description,
                    ),
                    SizesForm(product: product),
                    const SizedBox(height: 16),
                    Consumer<Product>(builder: (_, product, __) {
                      return TextButton(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                        ),
                        onPressed: !product.loading
                            ? () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  await product.saveProduct();
                                  context.read<ProductManager>().update(product);
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        child: !product.loading
                            ? const Text("Guardar")
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
