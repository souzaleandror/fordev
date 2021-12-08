import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mocks/fake_surveys_factory.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(FakeSurveysFactory.makeApiJson());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
  test('Should return surveys on 200', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        didAnswer: list[0]['didAnswer'],
        dateTime: DateTime.parse(list[0]['date']),
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        didAnswer: list[1]['didAnswer'],
        dateTime: DateTime.parse(list[1]['date']),
      ),
    ]);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    mockHttpData(FakeSurveysFactory.makeInvalidApiJson());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load(); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500 => NotFound',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load(); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403 ', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load(); //action

    expect(future, throwsA(DomainError.accessDenied));
  });
}
