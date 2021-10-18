import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;
  CompareFieldsValidation(
      {@required this.field, @required this.valueToCompare});

  @override
  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }

  @override
  List get props => [field, valueToCompare];
}
