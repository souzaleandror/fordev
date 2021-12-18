import 'dart:async';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:mocktail/mocktail.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final surveyResultController = StreamController<SurveyResultViewModel?>();

  SurveyResultPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.save(answer: any(named: 'answer')))
        .thenAnswer((_) async => _);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
  }

  void emitSessionExpiredError() => isSessionExpiredController.add(false);
  void emitSessionExpiredValid() => isSessionExpiredController.add(true);
  void emitLoading({bool show = true}) => isLoadingController.add(show);
  void emitSurveyResult(SurveyResultViewModel? data) =>
      surveyResultController.add(data);
  void emitSurveyResultError(String error) =>
      surveyResultController.addError(error);

  void dispose() {
    isSessionExpiredController.close();
    isLoadingController.close();
    surveyResultController.close();
  }
}
