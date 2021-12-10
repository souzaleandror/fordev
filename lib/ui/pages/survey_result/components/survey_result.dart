import 'package:flutter/material.dart';

import '../../../../ui/pages/survey_result/components/components.dart';
import '../../../../ui/pages/survey_result/survey_result.dart';

class SurveyResult extends StatelessWidget {
  const SurveyResult({Key? key, required this.viewModel, required this.onSave})
      : super(key: key);

  final SurveyResultViewModel viewModel;
  final void Function({required String answer}) onSave;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: viewModel.answers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SurveyHeader(
              question: viewModel.question,
            );
          }
          final answer = viewModel.answers[index - 1];
          return GestureDetector(
              onTap: () =>
                  answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
              child: SurveyAnswer(viewModel: answer));
        },
      );
}
