abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<dynamic>> get surveyResultStream;
  Future<void> loadData();
}
