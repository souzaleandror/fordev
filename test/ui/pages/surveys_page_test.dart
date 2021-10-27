import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
            name: '/surveys',
            page: () => SurveysPage(
                  presenter: presenter,
                ))
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Shouldcall LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
