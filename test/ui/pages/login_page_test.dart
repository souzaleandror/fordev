import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {

  LoginPresenter presenter;

  Future <void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }
  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    // Pegar Widget with labelText = 'Email' e verificar se tem mais de um propriedade Text como filho desse componente;
    // Porque ja temos o labelText para colocar o nome desse campo na tela
    // E para apresentar o erro, temos errorText, ou seja, se tive mais de um componente filho Text, e porque temos um erro
    final emailTextChildrem = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(
      emailTextChildrem, 
      findsOneWidget, 
      reason: 'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

      final passwordTextChildrem = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

      expect(
      passwordTextChildrem, 
      findsOneWidget, 
      reason: 'When a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

      // Aqui temos que retornar um widget, porque vamos comparar uma funcao e por isso temos que usar o tester.widget
      // E retornamos um widget e assim podemos usar a propriedade onPressed do button
      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct value', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    
    verify(presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);
    
    verify(presenter.validatePassword(senha));

  });
}