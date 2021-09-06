import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';


class ClientSpy extends Mock implements Client {}

void main() {

  HttpAdapter sut;
  ClientSpy client;
  String url;
  Uri uri;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
  });

  group('post', () {

    PostExpectation mockRequest() => when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }
    
    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(url, headers: {'content-type': 'application/json', 'accept': 'application/json'}, body: '{"any_key":"any_value"}'));
      //verify(response);
    });

    test('Should call post with without body', () async {
      await sut.request(url: url, method: 'post');
      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should returns data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should returns null if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should returns null if post returns 204', () async {
      mockResponse(204, body: '');
      
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should returns null if post returns 204 with data', () async {
      mockResponse(204);
      
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Should returns BadRequestError if post returns 400', () async {
      mockResponse(400);
      
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns BadRequestError if post returns 400', () async {
      mockResponse(400, body: '');
      
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns UnauthorizedError if post returns 4001', () async {
      mockResponse(401);
      
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should returns BadRequestError if post returns 500', () async {
      mockResponse(500);
      
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
