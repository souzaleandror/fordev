import 'package:equatable/equatable.dart';

import '../../ui/presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;
  RequiredFieldValidation(this.field);

  ValidationError validate(Map input) {
    return input[field]?.isNotEmpty == true
        ? null
        : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}
