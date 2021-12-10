import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/mixins/mixins.dart';
import '../../../ui/helpers/i18n/resources.dart';
import './components/components.dart';
import './login.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Builder para voce poder exibir o loading em cima da tela do singleScrollView view
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);

          handleMainError(context, presenter.mainErrorStream);

          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.login,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      32,
                    ),
                    child: Provider<LoginPresenter>(
                      create: (context) => presenter,
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
                            ElevatedButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: Icon(Icons.person),
                              label: Text(
                                R.strings.addAccount,
                              ),
                            )
                          ],
                        ),
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
