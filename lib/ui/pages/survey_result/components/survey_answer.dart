import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';

class SurveyAnswer extends StatelessWidget {
  const SurveyAnswer({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final SurveyAnswerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      List<Widget> children = [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              viewModel.answer,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Text(
          viewModel.percent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        viewModel.isCurrentAnswer ? ActiveIcon() : DisabledIcon(),
      ];
      if (viewModel.image != null) {
        children.insert(
          0,
          viewModel.image != null
              ? Image.network(
                  viewModel.image,
                  width: 40,
                )
              : SizedBox(
                  height: 0,
                ),
        );
      }
      return children;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildItems()),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
