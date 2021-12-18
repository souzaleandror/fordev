import 'package:flutter/material.dart';

import '../../ui/helpers/i18n/i18n.dart';

Future<void> showLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => SimpleDialog(
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
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.of(context).pop();
}
