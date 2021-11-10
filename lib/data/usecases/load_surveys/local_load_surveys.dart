import 'package:flutter/material.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class LocalLoadSurveys {
  FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await fetchCacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return data
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
