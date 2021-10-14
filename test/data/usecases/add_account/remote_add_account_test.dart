import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAddAccount sut;
  HttpClientSpy httpClient;
  String url;
  AddAccountParams params;

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
}
