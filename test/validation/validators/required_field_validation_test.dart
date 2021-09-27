import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation {
  final String field;
  RequiredFieldValidation(this.field);
  String validate(String value) {
    return value.isEmpty ? 'Campo obrigatorio' : null;
  }
}

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  test('Should return null if valure is not empty', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return null if valure is empty', () {
    expect(sut.validate(''), 'Campo obrigatorio');
  });
}
