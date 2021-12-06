import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';

class FakeSurveyResultFactory {
  static Map makeCacheJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'true',
            'percent': '40',
          },
          {
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'false',
            'percent': '60',
          },
        ],
      };

  static Map makeInvalidCacheJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          }
        ]
      };

  static Map makeIncompleteCacheJson() => {
        'surveyId': faker.guid.guid(),
      };

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            percent: 40,
            isCurrentAnswer: true,
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            percent: 60,
            isCurrentAnswer: false,
          ),
        ],
      );

  static SurveyResultViewModel makeViewModel() => SurveyResultViewModel(
        surveyId: 'Any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            image: 'Image 0',
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  static Map makeApiJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ],
        'date': faker.date.dateTime().toString(),
      };

  static Map makeInvalidApiJson() => {'invalid_key': 'invalid_value'};
}
