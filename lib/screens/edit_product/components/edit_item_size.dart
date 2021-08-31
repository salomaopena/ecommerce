//@dart=2.9
import 'package:ecommerce/models/item_size.dart';
import 'package:ecommerce/utils/custom_icon_button.dart';
import 'package:flutter/material.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize({
    Key key,
    @required this.size,
    @required this.onRemove,
    @required this.onMoveDown,
    @required this.onMoveUp,
  }) : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Tamanho',
              isDense: true,
            ),
            onChanged: (name) => size.name = name,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            validator: (name) {
              if (name.isEmpty) {
                return 'Inválido!';
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            onChanged: (stock) => size.stock = int.tryParse(stock),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock) == null) {
                return 'Inválido!';
              } else if (int.tryParse(stock) < 0) {
                return 'Número inválido!';
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            flex: 40,
            child: TextFormField(
              initialValue: size.price?.toStringAsFixed(2),
              decoration: const InputDecoration(
                labelText: 'Preço',
                isDense: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (price) => size.price = num.tryParse(price),
              validator: (price) {
                if (num.tryParse(price) == null) {
                  return 'Inválido!';
                } else if (num.tryParse(price) < 0) {
                  return 'Número inválido!';
                }
                return null;
              },
            )),
        CustomIconButton(
          icon: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          icon: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          icon: Icons.arrow_drop_down_sharp,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
