import 'package:fordev/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  PasswordValidation sut;

  setUp(() {
    sut = PasswordValidation('any_field');
  });
  test('Should return null if password is empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if password is null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if password is valid', () {
    expect(sut.validate({'any_field': '1234567Ab@'}), null);
  });

  // test('Should return error if password is invalid', () {
  //   expect(sut.validate('example'), UIError.invalidPassword);
  // });
}
