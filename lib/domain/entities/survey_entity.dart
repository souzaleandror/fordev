import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  @override
  List get props => [id, question, date, didAnswer];

  SurveyEntity(this.id, this.question, this.date, this.didAnswer);
}
