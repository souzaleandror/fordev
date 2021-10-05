import 'package:fordev/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}
