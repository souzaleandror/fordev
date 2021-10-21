import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  //Change idiom
  //R.load(Locale('en', 'US'));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Change color time and battery in top bar IOs
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: '/login', page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(
          name: '/signup',
          page: makeSignUpPage,
        ),
        GetPage(
            name: '/surveys',
            page: () => Scaffold(
                  body: Text(R.strings.surveys),
                ),
            transition: Transition.fadeIn),
      ],
    );
  }
}
