import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fordev/domain/entities/account_entity.dart';
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
    final account = await loadCurrentAccount.load();
    _navigateTo.value = account.isNull ? '/login' : '/surveys';
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  void mockLoadCurrentAccount({AccountEntity account}) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => account);
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
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

  test('should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
