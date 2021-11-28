import 'package:flutter/material.dart';
import 'package:fordev/ui/mixins/mixins.dart';
import 'splash_presenter.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  final SplashPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(presenter.navigateToStream, clear: true);
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
