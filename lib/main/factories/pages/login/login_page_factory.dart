import 'package:flutter/material.dart';
import 'package:fordev/main/factories/pages/login/login.dart';
import 'package:fordev/ui/pages/pages.dart';

Widget makeLoginPage() {
  return LoginPage(makeLoginPresenter());
}
