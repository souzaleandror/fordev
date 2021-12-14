import 'package:faker/faker.dart';
import 'package:fordev/infra/cache/cache.dart';
import 'package:matcher/src/type_matcher.dart' as type;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks/mocks.dart';

void main() {
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    value = faker.guid.guid();
    key = faker.lorem.word();
    secureStorage = FlutterSecureStorageSpy();
    secureStorage.mockFetch(value);
    sut = SecureStorageAdapter(secureStorage: secureStorage);
  });

  group('Save Secure', () {
    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      secureStorage.mockSaveError();
      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(type.TypeMatcher<Exception>()));
    });
  });

  group('FetchSecure', () {
    test('Should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throws', () async {
      secureStorage.mockFetchError();
      final future = sut.fetch(key);

      expect(future, throwsA(type.TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      secureStorage.mockDeleteError();
      final future = sut.delete(key);

      expect(future, throwsA(type.TypeMatcher<Exception>()));
    });
  });
}
