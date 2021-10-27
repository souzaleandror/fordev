import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({Key key, this.viewModel}) : super(key: key);

  final SurveyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: viewModel.didAnswer
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              spreadRadius: 0,
              blurRadius: 2,
              color: Colors.black,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.date,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              viewModel.question,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
