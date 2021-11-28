import 'package:fordev/ui/helpers/helpers.dart';
import 'package:get/get.dart';

mixin UIErrorManager {
  var _mainError = Rx<UIError>();
  Stream<UIError> get mainErrorStream => _mainError.stream;

  set mainError(UIError value) => _mainError.value = value;
}
