import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  String _email;
  String _name;
  String _password;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
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

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
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
  // TODO: implement navigateToStream
  Stream<String> get navigateToStream => throw UnimplementedError();

  @override
  // TODO: implement passwordConfirmationErrorStream
  Stream<UIError> get passwordConfirmationErrorStream =>
      throw UnimplementedError();

  @override
  Future<void> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    // TODO: implement validatePasswordConfirmation
  }
}
