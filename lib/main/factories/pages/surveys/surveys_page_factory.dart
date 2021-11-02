import 'package:flutter/material.dart';
import '../../../../ui/pages/surveys/surveys_page.dart';
import '../../factories.dart';

Widget makeSurveysPage() => SurveysPage(
      presenter: makeGetxSurveysPresenter(),
    );
