import 'package:fordev/domain/entities/account_entity.dart';

abstract class SaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
