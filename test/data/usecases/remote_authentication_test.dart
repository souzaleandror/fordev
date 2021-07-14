import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/usesCases/usesCases.dart';

class RemoteAuthentication {
  final HttpClient? httpClient;
  final String? url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
    await httpClient?.request(url: url, method: 'post', body: body);
    //await httpClient.request(url: url, method: 'get'); //falhar o test metodo errado (Espera um post)
    //await httpClient.request(url: 'http://asdasd', method: 'post'); //falhar o test url errada (Espera a mesma url passada no construtor da classe HttpClient)
  }
}

abstract class HttpClient {
  Future<void>? request({required String? url, required method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;

  //Passar para todos os testes
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url); //classe de teste chama sempre sut
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    await sut?.auth(params); //action

    //expect();
    verify(httpClient?.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.secret}
      ));
  });
}
