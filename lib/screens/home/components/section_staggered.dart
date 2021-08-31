// @dart=2.9
import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/section.dart';
import 'package:ecommerce/screens/home/components/add_tile_widget.dart';
import 'package:ecommerce/screens/home/components/item_tile.dart';
import 'package:ecommerce/screens/home/components/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  const SectionStaggered({@required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SectionHeader(),
            ),
            Consumer<Section>(builder: (_, section, __) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    if (index < section.items.length) {
                      return ItemTile(item: section.items[index]);
                    } else {
                      return AddTileWidget();
                    }
                  },
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1),
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
