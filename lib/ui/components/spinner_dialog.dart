import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';

void showLoading(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      child: SimpleDialog(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                R.strings.wait,
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
