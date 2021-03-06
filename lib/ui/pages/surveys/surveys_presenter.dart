import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;
  Future<void> loadData();
  Stream<bool> get isSessionExpiredStream;

  void goToSurveyResult(String surveyId);
}
