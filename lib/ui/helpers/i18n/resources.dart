import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = PtBr();

  static void load(Locale locale) {
    print(locale.toString());
    switch (locale.toString()) {
      case 'en_US':
        strings = EnUs();
        break;
      default:
        strings = PtBr();
        break;
    }
  }
}
