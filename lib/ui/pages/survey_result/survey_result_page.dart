import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/i18n/i18n.dart';

class SurveyResultPage extends StatelessWidget {
  const SurveyResultPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Text('Ok'),
    );
  }
}
