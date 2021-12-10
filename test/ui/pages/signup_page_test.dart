import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/heleprs.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToController;

  void initStreams() {
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<UIError?>();
    navigateToController = StreamController<String?>();
  }

  void mockStreams() {
    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();

    initStreams();
    mockStreams();
    await tester.pumpWidget(
        makePage(path: '/signup', page: () => SignUpPage(presenter)));
  }

  tearDown(() {
    closeStreams();
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

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    emailErrorController.add(null);
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

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    nameErrorController.add(null);
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

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    passwordErrorController.add(null);
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

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo Invalido'), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatorio'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
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

    isFormValidController.add(true);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);
    final button = find.byType(ElevatedButton);
    isFormValidController.add(true);
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });
// teste foi substituido por esse => Should handle loading correctly
  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
// teste foi substituido por esse => Should handle loading correctly
  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
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
  });

  testWidgets('Should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text('Email ja esta uso.'), findsOneWidget);
  });

  testWidgets('Should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(find.text('Algo Errado Aconteceu. Tente Novamente em breve.'),
        findsOneWidget);
  });

  testWidgets('Should change page ', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/signup');

    navigateToController.add(null);
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
