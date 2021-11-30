import 'package:flutter/material.dart';
import 'package:fordev/data/models/models.dart';

import '../../cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  CacheStorage cacheStorage;

  LocalLoadSurveyResult({
    @required this.cacheStorage,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');

      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save({
    @required String surveyId,
    @required SurveyResultEntity surveyResult,
  }) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();
      await cacheStorage.save(key: 'survey_result/$surveyId', value: json);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}