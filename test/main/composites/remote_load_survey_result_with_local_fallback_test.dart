import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:mockito/mockito.dart';

class RemoteLoadSurveyResultWithLocalFllback {
  final RemoteLoadSurveyResult remote;
  RemoteLoadSurveyResultWithLocalFllback({this.remote});
  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  test('Should call remote LoadBySurvey', () async {
    final surveyId = faker.guid.guid();
    final remote = RemoteLoadSurveyResultSpy();
    final sut = RemoteLoadSurveyResultWithLocalFllback(remote: remote);
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
