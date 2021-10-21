import 'package:equatable/equatable.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class PasswordValidation extends Equatable implements FieldValidation {
  final String field;
  PasswordValidation(this.field);

  ValidationError validate(Map input) {
    final regex = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    final isValid = input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return isValid ? null : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}
