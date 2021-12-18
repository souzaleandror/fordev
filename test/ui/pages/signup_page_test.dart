import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/heleprs.dart';
import '../mocks/mocks.dart';

void main() {
  late SignUpPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    await tester.pumpWidget(
        makePage(path: '/signup', page: () => SignUpPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

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

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct value',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar Senha'), password);
    verify(() => presenter.validatePasswordConfirmation(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if name is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password confirmation is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordConfirmationError(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    presenter.emitPasswordConfirmationError(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    presenter.emitPasswordConfirmationValid();
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Confirmar Senha'),
          matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormValid();
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitFormError();
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);
    final button = find.byType(ElevatedButton);
    presenter.emitFormValid();
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });
// teste foi substituido por esse => Should handle loading correctly
  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading(show: true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
// teste foi substituido por esse => Should handle loading correctly
  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading(show: true);
    await tester.pump();
    presenter.emitLoading(show: false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text('Email ja esta uso.'), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo Errado Aconteceu. Tente Novamente em breve.'),
        findsOneWidget);
  });

  testWidgets('Should change page ', (WidgetTester tester) async {
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
    expect(currentRoute, '/signup');
  });

  testWidgets('Should call goToLogin on link Click',
      (WidgetTester tester) async {
    await loadPage(tester);
    //final button = find.byType(FlatButton);
    final button = find.text('Login');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToLogin()).called(1);
  });
}
