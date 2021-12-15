import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadBySurvey(SurveyResultEntity result) {
    this.mockLoadBySurveyCall().thenAnswer((_) async => result);
  }

  void mockLoadBySurveyError(DomainError error) =>
      this.mockLoadBySurveyCall().thenThrow(error);
}
