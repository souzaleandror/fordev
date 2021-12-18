import 'dart:async';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToController;

  SignUpPresenterSpy() {
    when(() => this.signUp()).thenAnswer((_) async => _);
    when(() => this.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => this.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void emitNameError(UIError error) => nameErrorController.add(error);
  void emitNameValid() => nameErrorController.add(null);
  void emitPasswordConfirmationError(UIError error) =>
      passwordConfirmationErrorController.add(error);
  void emitPasswordConfirmationValid() =>
      passwordConfirmationErrorController.add(null);
  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading({bool show = true}) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    nameErrorController.close();
    passwordConfirmationErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }
}
