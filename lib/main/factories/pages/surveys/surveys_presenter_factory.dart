import '../../factories.dart';

import '../../../../ui/pages/pages.dart';
import '../../../../ui/presentation/presenters/presenters.dart';

SurveysPresenter makeGetxSurveysPresenter() =>
    GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveysWithLocalFallback());
