import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  When mockRequest() => when(() => httpClient.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body')));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  //Passar para todos os testes
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
        httpClient: httpClient, url: url); //classe de teste chama sempre sut
    params = FakerParamsFactory.makeAuthentication();
    mockHttpData(FakerAccountFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    //final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());

    // when(() => httpClient!.request(
    //     url: any(named: 'url'),
    //     method: any(named: 'method'),
    //     body: any(named: 'body')))
    // .thenAnswer((_) async => {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut.auth(params); //action

    //expect();
    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400 => BadRequest',
      () async {
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenThrow(HttpError.badRequest);

    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenThrow(HttpError.notFound);

    mockHttpError(HttpError.notFound);

    final future = sut.auth(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500 => NotFound',
      () async {
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenThrow(HttpError.serverError);

    mockHttpError(HttpError.serverError);

    final future = sut.auth(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'Should throw InvalidCredentailsError if HttpClient returns 401 => unauthorized',
      () async {
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenThrow(HttpError.unauthorized);

    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params); //action

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200 ', () async {
    // final accessToken = faker.guid.guid();
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenAnswer((_) async => {'accessToken': accessToken, 'name': faker.person.name()});
    final account = await sut.auth(params); //action

    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    // when(() => httpClient!.request(
    //         url: any(named: 'url'),
    //         method: any(named: 'method'),
    //         body: any(named: 'body')))
    //     .thenAnswer((_) async => {'invalid_key': 'invalid_value'});

    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params); //action

    expect(future, throwsA(DomainError.unexpected));
  });
}
