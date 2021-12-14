import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    this.mockSaveCall();
    this.mockDeleteCall();
  }

  When mockDeleteCall() => when(() => this.delete(key: any(named: 'key')));
  void mockDelete() => this.mockDeleteCall().thenAnswer((_) => _);
  void mockDeleteError() =>
      when(() => this.mockDeleteCall().thenThrow(Exception()));

  When mockSaveCall() => when(
      () => this.write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() =>
      when(() => this.mockSaveCall()).thenThrow(Exception());

  When mockFetchCall() => when(() => this.read(key: any(named: 'key')));
  void mockFetch(String? data) =>
      this.mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() =>
      when(() => this.mockFetchCall()).thenThrow(Exception());
}
