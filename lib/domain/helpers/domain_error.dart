enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais invalidas';
      default:
        return 'Algo Errado Aconteceu. Tente Novamente em breve.';
    }
  }
}
