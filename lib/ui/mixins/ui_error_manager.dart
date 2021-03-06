import 'package:flutter/material.dart';

import '../../ui/components/components.dart';
import '../../ui/helpers/helpers.dart';

mixin UIErrorManager {
  void handleMainError(
    BuildContext context,
    Stream<UIError?> stream,
  ) {
    stream.listen((error) {
      showErrorMessage(context, error!.description);
    });
  }
}
