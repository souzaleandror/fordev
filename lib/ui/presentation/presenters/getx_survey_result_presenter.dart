import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/pages/survey_result/survey_result.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/errors/errors.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.saveSurveyResult,
    @required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult =
          await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map(
              (answer) => SurveyAnswerViewModel(
                image: answer.image,
                answer: answer.answer,
                percent: '${answer.percent}%',
                isCurrentAnswer: answer.isCurrentAnswer,
              ),
            )
            .toList(),
      );
      isLoading = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({@required String answer}) async {
    isLoading = true;
    final surveyResult = await saveSurveyResult.save(answer: answer);
    _surveyResult.value = SurveyResultViewModel(
      surveyId: surveyResult.surveyId,
      question: surveyResult.question,
      answers: surveyResult.answers
          .map(
            (answer) => SurveyAnswerViewModel(
              image: answer.image,
              answer: answer.answer,
              percent: '${answer.percent}%',
              isCurrentAnswer: answer.isCurrentAnswer,
            ),
          )
          .toList(),
    );
    isLoading = false;
  }
}
