// @dart=2.9
import 'package:ecommerce/models/page_manager.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 240,
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Flexible(
                  child: Text(
                'Loja do\nPena',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              )),
              Flexible(
                child: Text(
                  userManager.user != null
                      ? 'Olá, ${userManager.user.nome}'
                      : 'Anónimo',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (userManager.isLoggedIn) {
                      context.read<PageManager>().setPage(0);
                      userManager.signOut();
                    } else {
                      Get.to(()=>LoginScreen());
                    }
                  },
                  child: Text(
                    userManager.isLoggedIn ? 'Sair' : 'Entre ou cadastre-se',
                    style: TextStyle(
                        color: userManager.isLoggedIn
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
