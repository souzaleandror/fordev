import 'package:flutter/material.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<SurveyResultEntity> save({String answer}) async {
    try {
      final json = await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
