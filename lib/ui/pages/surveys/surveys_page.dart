import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/components/components.dart';

import '../../../ui/helpers/i18n/i18n.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  const SurveysPage({Key key, this.presenter}) : super(key: key);

  final SurveysPresenter presenter;

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
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

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 1,
              ),
              items: [
                SurveyItem(),
                SurveyItem(),
                SurveyItem(),
              ],
            ),
          );
        },
      ),
    );
  }
}
