import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import './../../mocks/mocks.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  When mockLoadCurrentAccountCall() => when(() => loadCurrentAccount.load());

  void mockLoadCurrentAccount({required AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: FakerAccountFactory.makeEntity());
  });
  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount(durationInSeconds: 0);
  });
}
