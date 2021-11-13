import 'package:flutter/material.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class LocalLoadSurveys implements LoadSurveys {
  CacheStorage cacheStorage;

  LocalLoadSurveys({
    @required this.cacheStorage,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return _map(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<List<SurveyEntity>> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');

      return _map(data);
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }

  List<SurveyEntity> _map(List<Map> list) => list
      .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
      .toList();
}
