import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/errors/errors.dart';
import '../../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _isSessionExpired = RxBool();
  final _surveys = Rx<List<SurveyViewModel>>();
  var _navigateTo = RxString();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer))
          .toList();
      _isLoading.value = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) =>
      _navigateTo.value = '/survey_result/$surveyId';
}
