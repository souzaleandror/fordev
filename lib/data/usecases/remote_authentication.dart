import 'package:fordev/domain/usecases/authentication.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient? httpClient;
  final String? url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    //final body = {'email': params.email, 'password': params.secret}; //refactoring criado toJson na classe
    //await httpClient?.request(url: url, method: 'post', body: params.toJson());
    //await httpClient.request(url: url, method: 'get'); //falhar o test metodo errado (Espera um post)
    //await httpClient.request(url: 'http://asdasd', method: 'post'); //falhar o test url errada (Espera a mesma url passada no construtor da classe HttpClient)
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    await httpClient?.request(url: url, method: 'post', body: body);
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
