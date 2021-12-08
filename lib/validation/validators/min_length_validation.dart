import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../ui/presentation/protocols/protocols.dart';
import '../../validation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;
  MinLengthValidation({@required this.field, @required this.size});

  @override
  ValidationError validate(Map input) =>
      input[field] != null && input[field].length >= size
          ? null
          : ValidationError.invalidField;

  @override
  List get props => [field, size];
}
