import '../../../domain/entities/entities.dart';
import '../../../ui/pages/survey_result/survey_result.dart';

extension SurveyAnswerEntityExntesion on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
        image: image,
        answer: answer,
        percent: '$percent%',
        isCurrentAnswer: isCurrentAnswer,
      );
}
