import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/heleprs.dart';
import '../mocks/mocks.dart';

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    await tester
        .pumpWidget(makePage(path: '/login', page: () => LoginPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    // Pegar Widget with labelText = 'Email' e verificar se tem mais de um propriedade Text como filho desse componente;
    // Porque ja temos o labelText para colocar o nome desse campo na tela
    // E para apresentar o erro, temos errorText, ou seja, se tive mais de um componente filho Text, e porque temos um erro
    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    // Aqui temos que retornar um widget, porque vamos comparar uma funcao e por isso temos que usar o tester.widget
    // E retornamos um widget e assim podemos usar a propriedade onPressed do button
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct value',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);

    verify(() => presenter.validatePassword(senha));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo Invalido'), findsOneWidget);
  });

  testWidgets('Should present error if email is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo obrigatorio'), findsOneWidget);
  });

  testWidgets('Should present error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  // testWidgets('Should present error if email is valid',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   emailErrorController.add('');
  //   // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
  //   await tester.pump();

  //   expect(
  //       find.descendant(
  //           of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
  //       findsOneWidget,
  //       reason:
  //           'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  // });

  testWidgets('Should present error if password is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.requiredField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo obrigatorio'), findsOneWidget);
  });

  testWidgets('Should present error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordValid();
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget,
        reason:
            'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  });

  // testWidgets('Should present error if password is valid',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   presenter.emitPasswordError('');
  //   // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
  //   await tester.pump();

  //   expect(
  //       find.descendant(
  //           of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
  //       findsOneWidget,
  //       reason:
  //           'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');
  // });

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

  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);
    final button = find.byType(ElevatedButton);
    presenter.emitFormValid();
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.auth()).called(1);
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

  testWidgets('Should present error message if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais invalidas'), findsOneWidget);
  });

  testWidgets('Should present error message if authentication throws',
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
    expect(currentRoute, '/login');
  });

  testWidgets('Should call gotoSignUp on link click',
      (WidgetTester tester) async {
    await loadPage(tester);
    //final button = find.byType(FlatButton);
    final button = find.text('Criar Conta');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.goToSignUp()).called(1);
  });

  // testWidgets('Should close streams on dispose', (WidgetTester tester) async {
  //   await loadPage(tester);

  //   addTearDown(() {
  //     verify(() => presenter.dispose()).called(1);
  //   });
  // });
}
