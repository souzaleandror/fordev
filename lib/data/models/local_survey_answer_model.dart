import 'package:flutter/material.dart';
import 'package:fordev/domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      ['answer', 'isCurrentAnswer', 'percent'],
    )) {
      throw Exception();
    }
    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
      percent: int.parse(json['percent']),
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) =>
      LocalSurveyAnswerModel(
        image: entity.image,
        answer: entity.answer,
        percent: entity.percent,
        isCurrentAnswer: entity.isCurrentAnswer,
      );

  Map<String, String> toJson() => {
        'image': image,
        'answer': answer,
        'percent': percent.toString(),
        'isCurrentAnswer': isCurrentAnswer.toString(),
      };
}