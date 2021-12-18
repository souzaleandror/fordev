import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart' as test;
import 'package:flutter/material.dart';
import '../helpers/heleprs.dart';
import '../mocks/mocks.dart';

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(
        makePage(path: '/', page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });
  testWidgets('Should presenter spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    test.expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkAccount()).called(1);
  });

  testWidgets('Should load page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentRoute, '/');
  });
}
