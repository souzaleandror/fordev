import 'package:flutter/material.dart';

import '../../../ui/pages/survey_result/survey_result.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<SurveyResultViewModel?> get surveyResultStream;

  Future<void> loadData();
  Future<void> save({required String answer});
}
