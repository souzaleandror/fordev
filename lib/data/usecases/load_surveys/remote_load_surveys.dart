import 'package:flutter/material.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: 'get');
      return httpResponse
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
