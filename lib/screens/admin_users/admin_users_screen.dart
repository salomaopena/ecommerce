// @dart=2.9
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:ecommerce/common/custom_drawer/custom_drawer.dart';
import 'package:ecommerce/models/admin_users_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          'Utilizadores',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUserManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(
                  adminUserManager.users[index].nome,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(adminUserManager.users[index].email,
                    style: const TextStyle(color: Colors.white)),
              );
            },
            keyboardUsage: true,
            strList: adminUserManager.names,
            indexedHeight: (index) => 80,
            showPreview: true,
            highlightTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          );
        },
      ),
    );
  }
}
