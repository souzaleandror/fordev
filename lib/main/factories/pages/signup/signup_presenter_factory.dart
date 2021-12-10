import '../../../../main/factories/factories.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../ui/presentation/presenters/presenters.dart';

SignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
