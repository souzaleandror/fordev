import 'package:fordev/data/usecases/save_current_account/save_current_account.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/cache/cache.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeSecureStorageAdapter());
}
