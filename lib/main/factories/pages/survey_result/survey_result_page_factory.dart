import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/survey_result/survey_result.dart';
import '../../factories.dart';

Widget makeSurveyResultPage() => SurveyResultPage(
    presenter: makeGetxSurveyResultPresenter(Get.parameters['survey_id']));
