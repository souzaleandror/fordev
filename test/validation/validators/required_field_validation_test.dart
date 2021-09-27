import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation {
  final String field;
  RequiredFieldValidation(this.field);
  String validate(String value) {
    return null;
  }
}

void main() {
  test('Should return null if valure is not empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('any_field');

    expect(error, null);
  });
}
