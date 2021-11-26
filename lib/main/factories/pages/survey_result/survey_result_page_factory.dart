import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:get/get.dart';
import '../../factories.dart';

Widget makeSurveyResultPage() => SurveyResultPage(
    presenter: makeGetxSurveyResultPresenter(Get.parameters['survey_id']));
