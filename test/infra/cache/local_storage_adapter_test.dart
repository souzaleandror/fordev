import 'package:faker/faker.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fordev/infra/cache/cache.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:matcher/src/type_matcher.dart' as type;

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('Save Secure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());
    }

    test('Should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockSaveSecureError();
      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(type.TypeMatcher<Exception>()));
    });
  });

  group('FetchSecure', () {
    PostExpectation mockGetchSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    void mockFetchSecure() {
      mockGetchSecureCall().thenAnswer((_) async => value);
    }

    void mockFetchSecureError() {
      mockGetchSecureCall().thenThrow(Exception());
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure with correct values', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key);

      expect(fetchedValue, value);
    });

    test('Should throw if fetch secure throws', () async {
      mockFetchSecureError();
      final future = sut.fetchSecure(key);

      expect(future, throwsA(type.TypeMatcher<Exception>()));
    });
  });
}
