import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable{
  final String email;
  final String secret;

  AuthenticationParams({@required this.email, @required this.secret});

  @override
  List get props => [email, secret];

  //Map toJson() => {'email': email, 'password': secret}; //ruim colocar nome da propriedade que vem da API, tem que ficar generico isso por password o nome pode mudar para pwd
}
