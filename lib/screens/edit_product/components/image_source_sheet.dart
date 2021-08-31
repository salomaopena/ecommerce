//@dart=2.9
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({this.onImageSelected});

  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();



  @override
  Widget build(BuildContext context) {

    Future<void> editImage(String path) async{
      final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Ajustar imagem',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        iosUiSettings: const IOSUiSettings(
            title: 'Ajustar imagem',
            cancelButtonTitle: 'Cancelar',
            doneButtonTitle: 'Concluir'),
      );
      if(croppedFile!=null){
        onImageSelected(croppedFile);
      }
    }

    return Platform.isAndroid
        ? BottomSheet(
            onClosing: () {},
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () async {
                      final XFile file =
                          await picker.pickImage(source: ImageSource.camera);
                      editImage(file.path);
                    },
                    icon: Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final XFile file =
                          await picker.pickImage(source: ImageSource.gallery);
                      editImage(file.path);
                    },
                    icon: Icon(
                      Icons.photo,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          )
        : CupertinoActionSheet(
            title:
                const Text('Seleccionar a foto...', style: TextStyle(fontSize: 16)),
            message: const Text('Escolha a origem da foto'),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            actions: [
              CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () async {
                  final XFile file =
                      await picker.pickImage(source: ImageSource.camera);
                  editImage(file.path);
                },
                child: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  final XFile file =
                      await picker.pickImage(source: ImageSource.gallery);
                  editImage(file.path);
                },
                child: Icon(
                  Icons.photo,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          );
  }
}
