import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/presentation/protocols/validation.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late AccountEntity account;

  setUp(() {
    account = EntityFactory.makeAccount();
    email = faker.internet.email();
    password = faker.internet.password();
    validation = ValidationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);

    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    final formData = {'email': email, 'password': null};

    verify(() => validation.validate(field: 'email', input: formData))
        .called(1);
  });

  test('Should emit invalid field email error if email is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    // chamar somente uma vez
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit required field email error if email is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    // chamar somente uma vez
    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
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

  test('Should emit required field password error if password is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

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

  test('Should disable form button if any field invalid', () {
    validation.mockValidationError(
        field: 'email', value: ValidationError.invalidField);

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    // chamar somente uma vez
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

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentailsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));
    //sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidCredentials)));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    //sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    //sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test('Should go to SignUpPage on link click', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/signup')));
    sut.goToSignUp();
  });
}
