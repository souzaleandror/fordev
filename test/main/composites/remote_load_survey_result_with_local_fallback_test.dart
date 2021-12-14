import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mocktail/mocktail.dart';
import '../../data/usecases/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late String surveyId;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUp(() {
    surveyId = faker.guid.guid();
    localResult = EntityFactory.makeSurveyResult();
    local = LocalLoadSurveyResultSpy();
    local.mockLoadBySurvey(localResult);
    remoteResult = EntityFactory.makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    remote.mockLoadBySurvey(remoteResult);
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteResult)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteResult);
  });
  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError',
      () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should return local data', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localResult);
  });

  test('Should throw UnexpedError if local load fails', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();
    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
