import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/http/http.dart';

AddAccount makeRemoteAddAccount() =>
    RemoteAddAccount(httpClient: makeHttpAdapter(), url: makeApiUrl('signup'));
