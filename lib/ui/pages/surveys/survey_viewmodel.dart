import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SurveyViewModel extends Equatable {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  SurveyViewModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  List get props => [id, question, didAnswer, date];
}
