//@dart=2.9
import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/section.dart';
import 'package:flutter/material.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({this.homeManager});

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'List'));
          },
          child: const Text(
            'Adicionar Lista',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'Staggered'));
          },
          child: const Text(
            'Adicionar Grades',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
      ],
    );
  }
}
