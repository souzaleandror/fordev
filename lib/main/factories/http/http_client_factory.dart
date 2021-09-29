import 'package:flutter/material.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';
import 'package:fordev/infra/http/http.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import 'package:fordev/validation/validators/validators.dart';
import 'package:http/http.dart';

Widget makeLoginPage() {
  final url = 'http://fordevs.herokuapp.com/api/login';
  final client = Client();
  final httpAdapter = HttpAdapter(client);

  final remoteAuthentication =
      RemoteAuthentication(httpClient: httpAdapter, url: url);

  final validationComposite = ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
    PasswordValidation('password'),
  ]);

  final streamLoginPresenter = StreamLoginPresenter(
    authentication: remoteAuthentication,
    validation: validationComposite,
  );
  return LoginPage(streamLoginPresenter);
}
