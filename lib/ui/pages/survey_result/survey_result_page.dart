import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';

import '../../helpers/i18n/i18n.dart';
import 'components/components.dart';

class SurveyResultPage extends StatelessWidget {
  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  final SurveyResultPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.loadData();
        return StreamBuilder<dynamic>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RealodScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyResult();
              }
              return Container();
            });
      }),
    );
  }
}
