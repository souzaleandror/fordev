import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/main/factories/factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeLocalStoarageAdapter());
}
