import 'package:faker/faker.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/load_current_account/load_current_account.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late String token;

  When mockFetchSecureCall() =>
      when(() => fetchSecureCacheStorage.fetch(any()));

  void mockFetchSecure(String? data) {
    mockFetchSecureCall().thenAnswer((_) async => data);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure(token);
  });
  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(
      () => fetchSecureCacheStorage.fetch('token'),
    );
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throw',
      () async {
    mockFetchSecureError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw UnexpectedError if FetchSecureCacheStorage return null',
      () async {
    mockFetchSecure(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
