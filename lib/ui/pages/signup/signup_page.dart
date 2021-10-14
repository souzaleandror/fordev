import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/resources.dart';

import 'components/components.dart';
import 'signup.dart';
import '../../components/components.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage();

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      // Builder para voce poder exibir o loading em cima da tela do singleScrollView view
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.addAccount,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      32,
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          NameInput(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 32,
                            ),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButton(),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.exit_to_app),
                            label: Text(
                              R.strings.login,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
