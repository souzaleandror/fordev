import 'package:flutter/material.dart';

import 'package:fordev/ui/pages/pages.dart';

import '../../factories.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
