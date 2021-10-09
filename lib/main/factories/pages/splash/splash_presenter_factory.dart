import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';

import '../../factories.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
