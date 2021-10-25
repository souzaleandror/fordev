import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toString(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toString(),
        }
      ];

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
    mockHttpData(mockValidData());
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
        date: DateTime.parse(list[0]['date']),
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        didAnswer: list[1]['didAnswer'],
        date: DateTime.parse(list[1]['date']),
      ),
    ]);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);

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
}
