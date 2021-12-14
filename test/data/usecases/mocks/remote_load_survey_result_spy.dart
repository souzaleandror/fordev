import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadBySurvey(SurveyResultEntity result) {
    this.mockLoadBySurveyCall().thenAnswer((_) async => result);
  }

  void mockLoadBySurveyError(DomainError error) =>
      this.mockLoadBySurveyCall().thenThrow(error);
}
