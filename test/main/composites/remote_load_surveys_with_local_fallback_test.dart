import 'package:fordev/data/usecases/load_surveys/load_surveys.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import './../../mocks/mocks.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late RemoteLoadSurveysWithLocalFallback sut;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  When mockRemoteLoadCall() => when(() => remote.load());

  void mockRemoteLoad() {
    remoteSurveys = FakeSurveysFactory.makeEntities();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  When mockLocalLoadCall() => when(() => local.load());

  void mockLocalLoad() {
    localSurveys = FakeSurveysFactory.makeEntities();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemoteLoad();
    mockLocalLoad();
  });
  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });
  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });
  test('Should return remote surveys', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });
  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);
    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);
    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });
  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);
    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });
  test('Should throw UnexpectedError if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
