import 'package:flutter/material.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<void> save({String answer}) async {
    try {
      await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
