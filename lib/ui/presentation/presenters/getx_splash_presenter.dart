import 'package:flutter/material.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});
  var _navigateTo = RxString();
  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = !account.isNull ? '/login' : '/surveys';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}
