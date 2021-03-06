import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;

  //Passar para todos os testes
  setUp(() {
    url = faker.internet.httpUrl();
    params = ParamsFactory.makeAddAccount();
    apiResult = ApiFactory.makeAccountJson();
    httpClient = HttpClientSpy();
    httpClient.mockRequest(apiResult);
    sut = RemoteAddAccount(
        httpClient: httpClient, url: url); //classe de teste chama sempre sut
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params); //action
    //expect();
    verify(() => httpClient.request(url: url, method: 'post', body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
        }));
  });

  test('Should throw UnexpectedError if HttpClient returns 400 => BadRequest',
      () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500 => NotFound',
      () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw emailInUse if HttpClient returns 403 => email in use',
      () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.add(params); //action

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200 ', () async {
    final account = await sut.add(params); //action

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    httpClient.mockRequest({'invalid_key': 'invalid_value'});

    final future = sut.add(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });
}
