import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> loadSurveysController;
  StreamController<String> navigateToController;
  StreamController<bool> isSessionExpiredController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
    isSessionExpiredController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    initStreams();
    mockStreams();
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      navigatorObservers: [routeObserver],
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(
            presenter: presenter,
          ),
        ),
        GetPage(
          name: '/any_route',
          page: () => Scaffold(
            appBar: AppBar(
              title: Text('Any Title'),
            ),
            body: Text('fake page'),
          ),
        ),
        GetPage(
          name: '/login',
          page: () => Scaffold(
            body: Text('fake login'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'Date 1', didAnswer: false),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: true,
        ),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys on reload', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');

    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should presenter error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo Errado Aconteceu. Tente Novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should presenter error if loadSurveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
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

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should call gotoSurveyResult on link click',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should logout', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/surveys');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });
  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/login');
    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');

    isSessionExpiredController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/surveys');
  });
}
