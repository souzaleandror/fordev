import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/presentation/protocols/validation.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late StreamLoginPresenter sut;
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late SaveCurrentAccount saveCurrentAccount;
  late String email;
  late String password;
  late String token;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field == null ? any(named: 'field') : field,
      input: any(named: 'input')));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAuthenticationCall() => when(() => authentication.auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(token: token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = StreamLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    final formData = {'email': email, 'password': null};
    verify(() => validation.validate(field: 'email', input: formData))
        .called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    // chamar somente uma vez
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    final formData = {'email': null, 'password': password};

    verify(() => validation.validate(field: 'password', input: formData))
        .called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: ValidationError.requiredField);

    // chamar somente uma vez
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit any field error if validation fails', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    // chamar somente uma vez
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test(
      'Should if two fields are validated and different state initial email && password',
      () async {
    // chamar somente uma vez
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication
        .auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentailsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, UIError.invalidCredentials)));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));
    sut.dispose();
    sut.validateEmail(email);
  });
}
