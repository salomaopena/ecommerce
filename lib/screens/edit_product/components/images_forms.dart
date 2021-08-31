//@dart = 2.9
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/screens/edit_product/components/image_source_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImagesForms extends StatelessWidget {
  const ImagesForms({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images){
        if(images.isEmpty){
          return 'Insira ao menos uma imagem';
        }else{
          return null;
        }
      },
      onSaved: (images) =>product.newImages = images,
      builder: (state) {
        //Restornar a imagem da galeria ou da camera
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (image is String)
                        Image.network(image, fit: BoxFit.cover)
                      else
                        Image.file(image as File, fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  );
                }).toList()
                  ..add(Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: primaryColor,
                        size: 50,
                      ),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ));
                        } else {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ));
                        }
                      },
                    ),
                  )),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            if(state.hasError)
              Container(
                margin: const EdgeInsets.only(left: 16, top: 16),
                alignment: Alignment.centerLeft,
                child: Text(state.errorText,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12
                ),),
              )
          ],
        );
      },
    );
  }
}
