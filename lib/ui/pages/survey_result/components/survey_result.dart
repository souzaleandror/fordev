import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';

class SurveyResult extends StatelessWidget {
  const SurveyResult({
    Key key,
    this.viewModel,
  }) : super(key: key);

  final SurveyResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(
            question: viewModel.question,
          );
        }
        return SurveyAnswer(viewModel: viewModel.answers[index - 1]);
      },
    );
  }
}
