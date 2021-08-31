//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CepInputField extends StatelessWidget {
  const CepInputField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '12.345-678'
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 16),
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
                  borderRadius: BorderRadius.all(Radius.circular(25))),
            ),
            onPressed: () {},
            child: const Text("Buscar CEP"))
      ],
    );
  }
}
