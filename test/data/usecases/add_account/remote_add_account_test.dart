import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  HttpClientSpy httpClient;
  String url;
  AddAccountParams params;

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  //Passar para todos os testes
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(
        httpClient: httpClient, url: url); //classe de teste chama sempre sut
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut?.add(params); //action
    //expect();
    verify(httpClient?.request(url: url, method: 'post', body: {
      'name': params.name,
      'email': params?.email,
      'password': params?.password,
      'passwordConfirmation': params?.passwordConfirmation,
    }));
  });

  test('Should throw UnexpectedError if HttpClient returns 400 => BadRequest',
      () async {
    mockHttpError(HttpError.badRequest);

    final future = sut?.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut?.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500 => NotFound',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut?.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw emailInUse if HttpClient returns 403 => email in use',
      () async {
    mockHttpError(HttpError.forbidden);

    final future = sut?.add(params); //action

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200 ', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut?.add(params); //action

    expect(account?.token, validData['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut?.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });
}
