import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<UIError> mainErrorController;

  void initStreams() {
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    mainErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    initStreams();
    mockStreams();

    final loginPage = GetMaterialApp(initialRoute: '/login', getPages: [
      GetPage(name: '/login', page: () => LoginPage(presenter)),
      GetPage(
        name: '/any_route',
        page: () => Scaffold(
          body: Text('fake page'),
        ),
      ),
    ]);
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
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
    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct value',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);

    verify(presenter.validatePassword(senha));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo Invalido'), findsOneWidget);
  });

  testWidgets('Should present error if email is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.requiredField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo obrigatorio'), findsOneWidget);
  });

  testWidgets('Should present error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
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

    passwordErrorController.add(UIError.requiredField);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    expect(find.text('Campo obrigatorio'), findsOneWidget);
  });

  testWidgets('Should present error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
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

  //   passwordErrorController.add('');
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

    isFormValidController.add(true);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    // forca uma rederizacao da tela e atualiza todos os componentes da tela com o estado novo
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);
    final button = find.byType(RaisedButton);
    isFormValidController.add(true);
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.auth()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.invalidCredentials);
    await tester.pump();

    expect(find.text('Credenciais invalidas'), findsOneWidget);
  });

  testWidgets('Should present error message if authentication throws',
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

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/login');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/login');
  });

  testWidgets('Should call gotoSignUp on link click',
      (WidgetTester tester) async {
    await loadPage(tester);
    //final button = find.byType(FlatButton);
    final button = find.text('Criar Conta');

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);
  });

  // testWidgets('Should close streams on dispose', (WidgetTester tester) async {
  //   await loadPage(tester);

  //   addTearDown(() {
  //     verify(presenter.dispose()).called(1);
  //   });
  // });
}
