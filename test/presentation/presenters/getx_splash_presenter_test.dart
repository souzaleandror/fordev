import 'package:fordev/ui/presentation/presenters/presenters.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    loadCurrentAccount.mockLoad(account: EntityFactory.makeAccount());
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
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
    loadCurrentAccount.mockLoadError();
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount(durationInSeconds: 0);
  });
}
