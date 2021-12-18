import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/heleprs.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    await tester.pumpWidget(makePage(
        path: '/surveys', page: () => SurveysPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys on reload', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');

    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading(show: true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(show: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading(show: true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should presenter error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo Errado Aconteceu. Tente Novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should presenter error if loadSurveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyResultList());
    await tester.pump();
    expect(find.text('Algo Errado Aconteceu. Tente Novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveysError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should call gotoSurveyResult on link click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveyResultList());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/surveys');
  });
  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpiredValid();
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpiredError();
    await tester.pump();
    expect(currentRoute, '/surveys');
  });
}
