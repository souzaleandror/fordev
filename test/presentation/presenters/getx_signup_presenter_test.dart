import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/ui/presentation/protocols/validation.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import './../../mocks/mocks.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetxSignUpPresenter sut;
  late ValidationSpy validation;
  late AddAccountSpy addAccount;
  late SaveCurrentAccount saveCurrentAccount;
  late String email;
  late String name;
  late String password;
  late String passwordConfirmation;
  late AccountEntity account;

  When mockValidationCall(String? field) => when(() => validation.validate(
      field: field == null ? any(named: 'field') : field,
      input: any(named: 'input')));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAddAccountCall() => when(() => addAccount.add(any()));

  void mockAddAccount(AccountEntity data) {
    account = data;
    mockAddAccountCall().thenAnswer((_) async => data);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  void mockSaveCurrentAccountError() {
    mockAddAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();

    mockValidation();
    mockAddAccount(FakerAccountFactory.makeEntity());
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null
    };

    verify(() => validation.validate(field: 'email', input: formData))
        .called(1);
  });

  test('Should emit invalid field email error if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit required field email error if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds email', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct name', () {
    sut.validateName(name);
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null
    };

    verify(() => validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalid field name error if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit required field name error if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds name', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null
    };

    verify(() => validation.validate(field: 'password', input: formData))
        .called(1);
  });

  test('Should emit invalid field password error if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit required field password error if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds password', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct confirmation password', () {
    sut.validatePasswordConfirmation(passwordConfirmation);
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation
    };

    verify(() =>
            validation.validate(field: 'passwordConfirmation', input: formData))
        .called(1);
  });

  test(
      'Should emit invalid field passwordConfirmation error if passwordConfirmation is invalid',
      () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test(
      'Should emit required field passwordConfirmation error if passwordConfirmation is empty',
      () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds passwordConfirmation', () {
    sut.passwordConfirmationErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    sut.validateName(email);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(email);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(email);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAcount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(() => addAccount.add(AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ))).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(password);

    await sut.signUp();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    //sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUse', () async {
    mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('Should go to LoginPage on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    sut.goToLogin();
  });
}
