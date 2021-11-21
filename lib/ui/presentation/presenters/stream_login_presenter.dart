import 'dart:async';
import 'package:meta/meta.dart';

import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../../ui/presentation/protocols/protocols.dart';

class LoginState {
  String email;
  String password;
  UIError emailError;
  UIError passwordError;
  UIError mainError;
  String navigateTo;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  var _controller = StreamController<LoginState>.broadcast();
  var _state = LoginState();

  Stream<UIError> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<UIError> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<UIError> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<String> get navigateToStream =>
      _controller?.stream?.map((state) => state.navigateTo)?.distinct();
  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();

  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  void _update() => _controller?.add(_state);

  UIError _validateField(String field) {
    final formData = {'email': _state.email, 'password': _state.password};
    var error = validation.validate(field: field, input: formData);
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
    _state.email = email;
    _state.emailError = _validateField('email');
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField('password');
    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      final account = await authentication.auth(
          AuthenticationParams(email: _state.email, secret: _state.password));
      await saveCurrentAccount.save(account);
      _state.navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UIError.invalidCredentials;
          break;
        default:
          _state.mainError = UIError.unexpected;
      }
      _state.isLoading = false;
      _update();
    }
  }

  @override
  void dispose() {
    _controller.close();
    _controller = null;
  }

  @override
  void goToSignUp() {
    _state.navigateTo = '/signup';
  }
}
