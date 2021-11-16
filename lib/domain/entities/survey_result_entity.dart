import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fordev/domain/entities/survey_answer_entity.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  @override
  List get props => [surveyId, question, dateTime, didAnswer, answers];

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    this.dateTime,
    @required this.didAnswer,
    @required this.answers,
  });
}
