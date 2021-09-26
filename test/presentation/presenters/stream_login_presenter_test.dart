import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/presentation/protocols/validation.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';


class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {

  StreamLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authentication;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }
 
  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');
    
    // chamar somente uma vez
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));
  
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));
  
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');
    
    // chamar somente uma vez
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));
  
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));
  
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit any field error if validation fails', () {
    mockValidation(field: 'email', value: 'error');
    
    // chamar somente uma vez
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    //expectLater(sut.emailErrorStream, emitsInOrder(['error', 'error']));
  
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should if two fields are validated and different state initial email && password', () async {  
    // chamar somente uma vez
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
  
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });


  test('Should call Authentication with correct values', () async {  
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });


}