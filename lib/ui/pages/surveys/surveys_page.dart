import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../ui/components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';

import '../../../ui/helpers/i18n/i18n.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  const SurveysPage({Key key, this.presenter}) : super(key: key);

  final SurveysPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RealodScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1,
                      //enableInfiniteScroll: false,
                    ),
                    items: snapshot.data
                        .map((viewModel) => SurveyItem(viewModel: viewModel))
                        .toList(),
                  ),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
