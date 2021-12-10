import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/surveys/components/components.dart';
import '../../../../ui/pages/surveys/surveys.dart';

class SurveyItems extends StatelessWidget {
  const SurveyItems({
    Key key,
    required this.viewModels,
  }) : super(key: key);

  final List<SurveyViewModel> viewModels;

  @override
  Widget build(BuildContext context) {
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
        items: viewModels
            .map((viewModel) => SurveyItem(viewModel: viewModel))
            .toList(),
      ),
    );
  }
}
