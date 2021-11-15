import '../../../../ui/pages/pages.dart';
import '../../../../ui/presentation/presenters/presenters.dart';
import '../../factories.dart';

SplashPresenter makeGetxSplashPresenter() =>
    GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
