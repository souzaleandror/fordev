import 'package:equatable/equatable.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class PasswordValidation extends Equatable implements FieldValidation {
  final String field;
  PasswordValidation(this.field);

  String validate(String value) {
    final regex = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid
        ? null
        : 'Campo Invalido - Mínimo de oito caracteres, pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial';
  }

  @override
  List get props => [field];
}
