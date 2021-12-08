import 'package:flutter/material.dart';

class Headline1 extends StatelessWidget {
  Headline1({@required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1,
      );
}
