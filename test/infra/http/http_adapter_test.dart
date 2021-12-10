import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('Should throw ServerError if valid method is provided', () async {
      final future = sut.request(
          url: url, method: 'invalid_method', body: {'any_key': 'any_value'});

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    When mockRequest() => when(() => client.post(any(),
        body: any(named: 'body'), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
          url: url,
          method: 'post',
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});

      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call post with without body', () async {
      await sut.request(url: url, method: 'post');
      verify(() => client.post(any(), headers: any(named: 'headers')));
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

    test('Should returns UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should returns ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should returns NotFoundError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should returns ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should returns ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    When mockRequest() =>
        when(() => client.get(any(), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call get with correct values', () async {
      await sut.request(url: url, method: 'get');

      verify(() => client.get(url, headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          }));

      await sut.request(
          url: url, method: 'get', headers: {'any_header': 'any_value'});

      verify(() => client.get(url, headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          }));
    });

    test('Should returns data if get returns 200', () async {
      final response = await sut.request(url: url, method: 'get');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should returns null if get returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('Should returns null if get returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('Should returns null if get returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });

    test('Should returns BadRequestError if get returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns BadRequestError if get returns 400 with body empty',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns UnauthorizedError if get returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should returns ForbiddenError if get returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should returns NotFoundError if get returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should returns ServerError if get returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should returns ServerError if get throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('put', () {
    When mockRequest() => when(() => client.put(any(),
        body: any(named: 'body'), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test('Should call put with correct values', () async {
      await sut
          .request(url: url, method: 'put', body: {'any_key': 'any_value'});

      verify(() => client.put(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
          url: url,
          method: 'put',
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});

      verify(() => client.put(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call put with without body', () async {
      await sut.request(url: url, method: 'put');
      verify(() => client.put(any(), headers: any(named: 'headers')));
    });

    test('Should returns data if put returns 200', () async {
      final response = await sut.request(url: url, method: 'put');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should returns null if put returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('Should returns null if put returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('Should returns null if put returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'put');

      expect(response, null);
    });

    test('Should returns BadRequestError if put returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns BadRequestError if put returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should returns UnauthorizedError if put returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should returns ForbiddenError if put returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should returns NotFoundError if put returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should returns ServerError if put returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should returns ServerError if put throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
