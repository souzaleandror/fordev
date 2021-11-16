import 'package:fordev/main/composites/composites.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/http/http.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys'));

LoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
        remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
