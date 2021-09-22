import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './components/components.dart';
import './login.dart';
import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Builder para voce poder exibir o loading em cima da tela do singleschildScroll view
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingController.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter.mainErrorController.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(
                  text: 'Login',
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    32,
                  ),
                  child: Provider<LoginPresenter>(
                    create: (context) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 32,
                            ),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.person),
                            label: Text(
                              'Criar Conta',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
