import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;
  List<SurveyEntity> surveys;
  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 02, 20),
            didAnswer: true),
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.lorem.sentence(),
            dateTime: DateTime(2021, 10, 03),
            didAnswer: false),
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on success', () async {
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
  test('Should emit correct events on fails', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description)));
    await sut.loadData();
  });
}
