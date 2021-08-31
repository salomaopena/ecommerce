// @dart=2.9
import 'package:ecommerce/common/custom_drawer/custom_drawer_header.dart';
import 'package:ecommerce/common/custom_drawer/drawer_tile.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white
          ], begin: Alignment.topCenter, end: Alignment.bottomRight))),
          ListView(
            children: [
              CustomDrawerHeader(),
              const Divider(
                indent: 32,
              ),
              const DrawerTile(
                iconData: Icons.home,
                title: "Início",
                page: 0,
              ),
              const DrawerTile(
                iconData: Icons.list,
                title: "Produtos",
                page: 1,
              ),
              const DrawerTile(
                iconData: Icons.playlist_add_check_rounded,
                title: "Meus Pedidos",
                page: 2,
              ),
              const DrawerTile(
                iconData: Icons.location_on_outlined,
                title: "Lojas",
                page: 3,
              ),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: [
                      const Divider(),
                      const DrawerTile(
                        iconData: Icons.shopping_bag,
                        title: "Pedidos",
                        page: 4,
                      ),
                      const DrawerTile(
                        iconData: Icons.supervised_user_circle_sharp,
                        title: "Utilizadores",
                        page: 5,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              })
            ],
          ),
        ],
      ),
    );
  }
}
