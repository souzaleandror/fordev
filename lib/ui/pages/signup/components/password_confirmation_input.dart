import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.passwordConfirmation,
        icon: Icon(
          Icons.lock_open,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      obscureText: true,
    );
  }
}
