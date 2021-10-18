import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';
import '../../../domain/usecases/add_account.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;
  String _email;
  String _name;
  String _password;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _isFormValid = false.obs;
  var _mainError = Rx<UIError>();
  var _isLoading = false.obs;
  var _navigateToStream = RxString();

  Stream<UIError> get emailErrorStream => _emailError.stream;
  Stream<UIError> get nameErrorStream => _nameError.stream;
  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<UIError> get mainErrorStream => _mainError.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get navigateToStream => _navigateToStream.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
    @required this.saveCurrentAccount,
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

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _nameError.value == null &&
        _passwordConfirmationError.value == null &&
        _email != null &&
        _password != null &&
        _name != null &&
        _passwordConfirmation != null;
  }

  void dispose() {}

  @override
  Future<void> signUp() async {
    try {
      _isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));
      await saveCurrentAccount.save(account);
      _navigateToStream.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
    }
    _isLoading.value = false;
  }
}
