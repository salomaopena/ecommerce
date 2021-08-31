// @dart=2.9
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criar conta",
          style: TextStyle(fontSize: 17),
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
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: "Nome completo"),
                      keyboardType: TextInputType.name,
                      validator: (nome) {
                        if (nome.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (nome.trim().split(" ").length <= 1) {
                          return 'Preeencha seu nome completo';
                        }
                        return null;
                      },
                      onSaved: (nome) => user.nome = nome,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "E-mail"),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!emailValid(email)) {
                          return 'E-mail inválido!';
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: "Password"),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (password.length < 6) {
                          return 'A senha muito fraca';
                        }
                        return null;
                      },
                      onSaved: (password) => user.password = password,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: "Confirmar password"),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (password2) {
                        if (password2.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (password2.length < 6) {
                          return 'A senha muito fraca';
                        }
                        return null;
                      },
                      onSaved: (password2) => user.password2 = password2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                            formKey.currentState.save();
                            if (user.password != user.password2) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Senha não coincidem"),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            userManager.signUp(
                              userModel: user,
                              onFail: (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Falha ao criar conta: $e"),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              onSuccess: () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                        child: !userManager.loading
                            ? const Text("Criar conta")
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              ))
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
