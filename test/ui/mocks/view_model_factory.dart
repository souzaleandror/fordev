import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';

class ViewModelFactory {
  static List<SurveyViewModel> makeSurveyResultList() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'Date 1', didAnswer: false),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: true,
        ),
      ];

  static SurveyResultViewModel makeSurveyResultResult() =>
      SurveyResultViewModel(
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
}
