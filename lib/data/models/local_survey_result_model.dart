import 'package:flutter/material.dart';
import 'package:fordev/data/models/models.dart';
import 'package:fordev/domain/entities/entities.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      ['surveyId', 'question', 'answers'],
    )) {
      throw Exception();
    }
    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<LocalSurveyAnswerModel>(
              (answerJson) => LocalSurveyAnswerModel.fromJson(answerJson))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers
            .map<SurveyAnswerEntity>((answer) => answer.toEntity())
            .toList(),
      );
}
