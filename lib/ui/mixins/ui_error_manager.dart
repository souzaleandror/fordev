import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/helpers/helpers.dart';

mixin UIErrorManager {
  void handleMainError(
    BuildContext context,
    Stream<UIError> stream,
  ) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}
