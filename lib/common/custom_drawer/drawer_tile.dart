// @dart=2.9
import 'package:ecommerce/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key key,
      @required this.iconData,
      @required this.title,
      @required this.page})
      : super(key: key);

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {

    final int currentPage = context.watch<PageManager>().page;
    final Color colorPrimary = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Flexible(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: currentPage == page ? colorPrimary : Colors.grey[700],
              ),
            )),
            Flexible(
                child: Text(
              title,
              style: TextStyle(
                  color: currentPage == page ? colorPrimary : Colors.grey[700],
                  fontSize: 16),
            ))
          ],
        ),
      ),
    );
  }
}
