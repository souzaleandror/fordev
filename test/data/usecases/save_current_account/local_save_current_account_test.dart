import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/save_current_account/save_current_account.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/account_entity.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorage saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void MockError() {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    MockError();
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
