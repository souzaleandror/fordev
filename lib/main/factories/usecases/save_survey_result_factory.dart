import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) =>
    RemoteSaveSurveyResult(
        httpClient: makeAuthorizeHttpClientDecorator(),
        url: makeApiUrl('surveys/$surveyId/results'));
