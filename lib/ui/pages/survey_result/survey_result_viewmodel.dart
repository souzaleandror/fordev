import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../ui/pages/survey_result/survey_result.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final DateTime dateTime;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    this.dateTime,
    @required this.answers,
  });

  List<Object> get props => ['surveyId', 'question', 'dateTime', 'answers'];
}
