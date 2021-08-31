// @dart=2.9
import 'package:ecommerce/common/custom_drawer/custom_drawer.dart';
import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/cart/cart_screen.dart';
import 'package:ecommerce/screens/home/components/add_sections_widget.dart';
import 'package:ecommerce/screens/home/components/section_list.dart';
import 'package:ecommerce/screens/home/components/section_staggered.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScrenn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 161)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                pinned: true,
                backgroundColor: const Color.fromARGB(255, 211, 118, 130),
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Pena'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => CartScreen());
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.shopping_cart),
                  ),
                  Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __) {
                    if (userManager.adminEnabled && !homeManager.loading) {
                      if (homeManager.editing) {
                        return PopupMenuButton(
                            onSelected: (e) {
                              if(e=='Guardar'){
                                homeManager.saveEditing();
                              }else{
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_) {
                              return ['Guardar', 'Descartar'].map((e) {
                                return PopupMenuItem(value: e, child: Text(e));
                              }).toList();
                            });
                      } else {
                        return IconButton(
                          onPressed: homeManager.enterEditing,
                          icon: Icon(Icons.edit),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {

                  if(homeManager.loading){
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }

                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                    switch (section.type) {
                      case 'List':
                        return SectionList(section: section);
                      case 'Staggered':
                        return SectionStaggered(section: section);
                      default:
                        return Container();
                    }
                  }).toList();
                  //Editar
                  if(homeManager.editing) {
                    children.add(AddSectionWidget(homeManager: homeManager));
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      children,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
