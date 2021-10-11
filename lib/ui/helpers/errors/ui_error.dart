import 'package:fordev/ui/helpers/i18n/i18n.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
  invalidPassword
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.invalidPassword:
        return R.strings.msgInvalidPassword;
      default:
        return R.strings.msgUnexpected;
    }
  }
}
