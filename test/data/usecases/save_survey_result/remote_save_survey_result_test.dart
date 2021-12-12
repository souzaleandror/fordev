import 'package:faker/faker.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../infra/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteSaveSurveyResult sut;
  late String answer;
  late Map surveyResult;

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    surveyResult = ApiFactory.makeSurveyResultJson();
    httpClient = HttpClientSpy();
    httpClient.mockRequest(surveyResult);
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });
  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(() =>
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.save(answer: answer);

    expect(
      result,
      SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
            image: surveyResult['answers'][0]['image'],
            answer: surveyResult['answers'][0]['answer'],
            isCurrentAnswer: surveyResult['answers'][0]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            answer: surveyResult['answers'][1]['answer'],
            isCurrentAnswer: surveyResult['answers'][1]
                ['isCurrentAccountAnswer'],
            percent: surveyResult['answers'][1]['percent'],
          ),
        ],
      ),
    );
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data ',
      () async {
    httpClient.mockRequest(ApiFactory.makeInvalidSurveyJson());

    final future = sut.save();

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw UnexpectedError if HttpClient returns 404 => NotFound',
      () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.save(); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500 => NotFound',
      () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.save(); //action

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403 ', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.save(); //action

    expect(future, throwsA(DomainError.accessDenied));
  });
}
