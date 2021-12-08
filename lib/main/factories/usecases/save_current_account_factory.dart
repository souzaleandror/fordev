import '../../../data/usecases/save_current_account/save_current_account.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/factories/cache/cache.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() =>
    LocalSaveCurrentAccount(saveSecureCacheStorage: makeSecureStorageAdapter());
