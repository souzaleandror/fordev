import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';

class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2020-07-20T00:00:00Z',
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'true',
        },
      ];

  static List<Map> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': 'invalid data',
          'didAnswer': 'false',
        }
      ];

  static List<Map> makeIncompleteCacheJson() => [
        {
          'date': 'invalid data',
          'didAnswer': 'false',
        }
      ];

  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2020, 2, 2),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2020, 12, 20),
          didAnswer: false,
        ),
      ];

  static List<SurveyViewModel> makeViewModel() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'Date 1', didAnswer: false),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: true,
        ),
      ];

  static List<Map> makeApiJson() => [
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

  static List<Map> makeInvalidApiJson() => [
        {'invalid_key': 'invalid_value'}
      ];
}
