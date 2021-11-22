import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';

class SurveyResultViewModel {
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
}