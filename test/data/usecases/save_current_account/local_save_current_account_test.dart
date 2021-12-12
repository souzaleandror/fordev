import 'package:faker/faker.dart';
import 'package:fordev/data/usecases/save_current_account/save_current_account.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/account_entity.dart';

import '../mocks/mocks.dart';

void main() {
  late LocalSaveCurrentAccount sut;
  late SecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    account = AccountEntity(token: faker.guid.guid());
    saveSecureCacheStorage = SecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
  });
  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(() =>
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    saveSecureCacheStorage.mockSaveError();
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
