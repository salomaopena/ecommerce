// @dart=2.9
import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/section.dart';
import 'package:ecommerce/screens/home/components/add_tile_widget.dart';
import 'package:ecommerce/screens/home/components/item_tile.dart';
import 'package:ecommerce/screens/home/components/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  const SectionList({@required this.section});
  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SectionHeader(),
            ),
            SizedBox(
              height: 150,
              child: Consumer<Section>(
                builder: (_, section, __) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      if (index < section.items.length) {
                        return ItemTile(item: section.items[index]);
                      } else {
                        return AddTileWidget();
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      width: 2,
                    ),
                    itemCount: homeManager.editing
                        ? section.items.length + 1
                        : section.items.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
