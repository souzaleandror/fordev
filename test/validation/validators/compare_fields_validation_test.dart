import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  CompareFieldsValidation sut;
  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  test('Should return error if value is not equal', () {
    expect(sut.validate('wrong_value'), ValidationError.invalidField);
  });
}
