import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;

  //Passar para todos os testes
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
        httpClient: httpClient, url: url); //classe de teste chama sempre sut
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    //final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());

    await sut?.auth(params!); //action

    //expect();
    verify(httpClient?.request(
        url: url,
        method: 'post',
        body: {'email': params?.email, 'password': params?.secret}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400 => BadRequest',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut?.auth(params!); //action

    expect(future, throwsA(DomainError.unexpected));
  });

    test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    when(httpClient!.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final future = sut?.auth(params!); //action

    expect(future, throwsA(DomainError.unexpected));
  });
}
