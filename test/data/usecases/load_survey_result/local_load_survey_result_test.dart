import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('loadBySurvey', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late Map data;
    late String surveyId;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });
    test('Should call CacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });
    test('Should return a surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              percent: 40,
              isCurrentAnswer: true,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              percent: 60,
              isCurrentAnswer: false,
            ),
          ],
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if method fetch fail', () async {
      mockFetchError();
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late Map data;
    late String surveyId;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });
    test('Should call CacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });
    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());
      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());
      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      mockFetchError();
      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('Save', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late SurveyResultEntity surveyResult;

    When mockSaveCall() => when(() => cacheStorage.save(
        key: any(named: 'key'), value: any(named: ('value'))));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyResult = FakeSurveyResultFactory.makeEntity();
    });
    test('Should call CacheStorage with correct values', () async {
      final json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false',
          },
        ],
      };

      await sut.save(surveyResult);

      verify(() => cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}',
          value: json)).called(1);
    });
    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
