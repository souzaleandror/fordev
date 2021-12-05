import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'survey_answer_entity_extension.dart';

extension SurveyResultEntityExntesion on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
        surveyId: surveyId,
        question: question,
        answers: answers.map((answer) => answer.toViewModel()).toList(),
      );
}
