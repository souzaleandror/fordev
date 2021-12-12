import 'package:fordev/data/usecases/load_surveys/load_surveys.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/cache_factory.dart';
import '../mocks/mocks.dart';

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveys sut;
  late List<Map> data;
  late List<SurveyEntity> surveys;

  setUp(() {
    surveys = EntityFactory.makeSurveyList();
    cacheStorage = CacheStorageSpy();
    data = CacheFactory.makeSurveyList();
    cacheStorage.mockFetch(data);
    sut = LocalLoadSurveys(cacheStorage: cacheStorage);
  });

  group('load', () {
    test('Should call CacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });
    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(
            id: data[0]['id'],
            question: data[0]['question'],
            dateTime: DateTime.utc(2020, 07, 20),
            didAnswer: false),
        SurveyEntity(
            id: data[1]['id'],
            question: data[1]['question'],
            dateTime: DateTime.utc(2019, 02, 02),
            didAnswer: true),
      ]);
    });
    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch([]);
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if method fetch fail', () async {
      cacheStorage.mockFetchError();
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    test('Should call CacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });
    test('Should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyList());
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
    test('Should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyList());
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch fails', () async {
      cacheStorage.mockFetchError();
      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('Save', () {
    test('Should call CacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': '2020-02-02T00:00:00.000Z',
          'didAnswer': 'true',
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': '2020-12-20T00:00:00.000Z',
          'didAnswer': 'false',
        },
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });
    test('Should throw UnexpectedError if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
