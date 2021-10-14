import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text(
        R.strings.addAccount.toUpperCase(),
      ),
    );
  }
}
