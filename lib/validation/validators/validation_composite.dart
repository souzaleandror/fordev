import 'package:flutter/material.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  ValidationError validate({@required String field, @required Map input}) {
    ValidationError error;
    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(input);

      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
