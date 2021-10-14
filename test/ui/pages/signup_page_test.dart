import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/pages/signup/signup_page.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(initialRoute: '/signup', getPages: [
      GetPage(name: '/signup', page: () => SignUpPage()),
    ]);
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

    expect(nameTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    final passwordTConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar Senha'),
        matching: find.byType(Text));

    expect(passwordTConfirmationTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    expect(passwordTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
