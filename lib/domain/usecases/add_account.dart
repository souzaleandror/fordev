import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParams(
      {@required this.name,
      @required this.email,
      @required this.password,
      @required this.passwordConfirmation});

  @override
  List get props => [name, email, password, passwordConfirmation];

  //Map toJson() => {'email': email, 'password': secret}; //ruim colocar nome da propriedade que vem da API, tem que ficar generico isso por password o nome pode mudar para pwd
}
