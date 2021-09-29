import 'package:fordev/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  PasswordValidation sut;

  setUp(() {
    sut = PasswordValidation('any_field');
  });
  test('Should return null if password is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if password is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if password is valid', () {
    expect(sut.validate('1234567Ab@'), null);
  });

  test('Should return error if password is invalid', () {
    expect(sut.validate('example'),
        'Campo Invalido - Mínimo de oito caracteres, pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial');
  });
}
