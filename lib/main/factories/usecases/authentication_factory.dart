import '../../../data/usecases/authentication/remote_authentication.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/http/http.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(
    httpClient: makeHttpAdapter(), url: makeApiUrl('login'));
