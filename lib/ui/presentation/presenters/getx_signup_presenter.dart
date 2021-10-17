import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  String _email;

  var _emailError = Rx<UIError>();
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    @required this.validation,
  });

  UIError _validateField({String field, String value}) {
    var error = validation.validate(field: field, value: value);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = false;
  }

  void dispose() {}

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  // TODO: implement mainErrorStream
  Stream<UIError> get mainErrorStream => throw UnimplementedError();

  @override
  // TODO: implement nameErrorStream
  Stream<UIError> get nameErrorStream => throw UnimplementedError();

  @override
  // TODO: implement navigateToStream
  Stream<String> get navigateToStream => throw UnimplementedError();

  @override
  // TODO: implement passwordConfirmationErrorStream
  Stream<UIError> get passwordConfirmationErrorStream =>
      throw UnimplementedError();

  @override
  // TODO: implement passwordErrorStream
  Stream<UIError> get passwordErrorStream => throw UnimplementedError();

  @override
  Future<void> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  void validateName(String name) {
    // TODO: implement validateName
  }

  @override
  void validatePassword(String password) {
    // TODO: implement validatePassword
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    // TODO: implement validatePasswordConfirmation
  }
}
