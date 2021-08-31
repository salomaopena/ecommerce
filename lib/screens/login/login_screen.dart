// @dart=2.9
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/signup/signup_screen.dart';
import 'package:ecommerce/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Entrar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!emailValid(email)) {
                          return 'E-mail inválido!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "Senha"),
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: false,
                      obscureText: true,
                      validator: (password) {
                        if (password.isEmpty || password.length < 6) {
                          return "Senha muito curta";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                            child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                              onPressed: () {
                                Get.to(()=>SignUpScreen());
                              },
                              child: const Text(
                                "Criar conta",
                                style: TextStyle(color: Colors.black),
                              )),
                        )),
                        Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Esqueci a minha senha",
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        )
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          userManager.sigIn(
                              user: UserModel(
                                email:emailController.text,
                                password:passwordController.text,
                              ),
                              onFail: (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Falha ao iniciar sessão: $e"),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              onSuccess: () {
                               Navigator.of(context).pop();
                              });
                        }
                      },
                      child: !userManager.loading
                          ? const Text("Iniciar sessao")
                          : const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
