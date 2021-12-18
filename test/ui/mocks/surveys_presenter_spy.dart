import 'dart:async';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final navigateToController = StreamController<String?>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final surveysController = StreamController<List<SurveyViewModel>>();

  SurveysPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.surveysStream).thenAnswer((_) => surveysController.stream);
  }

  void emitSessionExpiredError() => isSessionExpiredController.add(false);
  void emitSessionExpiredValid() => isSessionExpiredController.add(true);
  void emitLoading({bool show = true}) => isLoadingController.add(show);
  void emitSurveys(List<SurveyViewModel> data) => surveysController.add(data);
  void emitSurveysError(String error) => surveysController.addError(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    isSessionExpiredController.close();
    isLoadingController.close();
    surveysController.close();
    navigateToController.close();
    surveysController.close();
  }
}
