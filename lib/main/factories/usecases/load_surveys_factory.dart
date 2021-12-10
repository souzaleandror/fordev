import '../../../main/composites/composites.dart';
import '../../../data/usecases/usecases.dart';
import '../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(), url: makeApiUrl('surveys'));

LocalLoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

RemoteLoadSurveysWithLocalFallback makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
        remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
