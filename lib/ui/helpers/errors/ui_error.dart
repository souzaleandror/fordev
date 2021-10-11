enum UIError { unexpected, invalidCredentials, requiredField, invalidField, invalidPassword }

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return 'Campo obrigatorio';
      case UIError.invalidField:
        return 'Campo Invalido';
      case UIError.invalidCredentials:
        return 'Credenciais invalidas';
      case UIError.invalidPassword:
        return 'Credenciais invalidas';
      default:
        return 'Algo Errado Aconteceu. Tente Novamente em breve.';
    }
  }
}
