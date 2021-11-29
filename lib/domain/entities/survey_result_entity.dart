import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/survey_answer_entity.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final DateTime dateTime;
  final List<SurveyAnswerEntity> answers;

  @override
  List get props => [surveyId, question, dateTime, answers];

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    this.dateTime,
    @required this.answers,
  });
}
