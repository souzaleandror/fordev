import 'package:get/get.dart';

import '../../../ui/presentation/mixins/mixins.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/pages/pages.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      await loadCurrentAccount.load();
      navigateTo = '/surveys';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
