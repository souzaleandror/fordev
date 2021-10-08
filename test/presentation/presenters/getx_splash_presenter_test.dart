import 'package:flutter/material.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});
  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
    _navigateTo.value = '/surveys';
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;
  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });
  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });
}
