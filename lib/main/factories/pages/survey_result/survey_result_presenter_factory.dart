import '../../../../ui/pages/survey_result/survey_result.dart';
import '../../factories.dart';
import '../../../../ui/presentation/presenters/presenters.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) =>
    GetxSurveyResultPresenter(
        loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
        surveyId: surveyId);
