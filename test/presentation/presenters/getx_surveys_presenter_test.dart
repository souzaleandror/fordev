import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys
        .map((survey) => SurveyViewModel(
            id: survey.id,
            question: survey.question,
            date: DateFormat('dd MMM yyyy').format(survey.date),
            didAnswer: survey.didAnswer))
        .toList();
    _isLoading.value = false;
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;
  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            date: DateTime(2021, 02, 20),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            date: DateTime(2021, 10, 03),
            didAnswer: false),
      ];

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveys.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events od success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      expectAsync1(
        (surveys) => expect(
          surveys,
          [
            SurveyViewModel(
              id: surveys[0].id,
              didAnswer: surveys[0].didAnswer,
              question: surveys[0].question,
              date: '20 Fev 2021',
            ),
            SurveyViewModel(
              id: surveys[1].id,
              didAnswer: surveys[1].didAnswer,
              question: surveys[1].question,
              date: '03 Out 2021',
            ),
          ],
        ),
      ),
    );
    await sut.loadData();
  });
}
