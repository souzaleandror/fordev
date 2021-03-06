import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../../data/usecases/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  setUp(() {
    surveys = EntityFactory.makeSurveyList();
    loadSurveys = LoadSurveysSpy();
    loadSurveys.mockLoad(surveys);
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
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
              date: '02 Feb 2020',
            ),
            SurveyViewModel(
              id: surveys[1].id,
              didAnswer: surveys[1].didAnswer,
              question: surveys[1].question,
              date: '20 Dec 2020',
            ),
          ],
        ),
      ),
    );
    await sut.loadData();
  });
  test('Should emit correct events on fails', () async {
    loadSurveys.mockLoadError(DomainError.unexpected);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(
          error,
          UIError.unexpected.description,
        ),
      ),
    );
    await sut.loadData();
  });
  test('Should emit correct events on access denied', () async {
    loadSurveys.mockLoadError(DomainError.accessDenied);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    expectLater(sut.navigateToStream,
        emitsInOrder(['/survey_result/any_route', '/survey_result/any_route']));
    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });
}
