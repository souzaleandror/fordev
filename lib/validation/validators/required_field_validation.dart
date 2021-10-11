import 'package:equatable/equatable.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;
  RequiredFieldValidation(this.field);

  ValidationError validate(String value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}
