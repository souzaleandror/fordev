import '../../../../main/factories/factories.dart';
import '../../../../main/factories/usecases/save_current_account_factory.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../ui/presentation/presenters/presenters.dart';

SignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      addAccount: makeRemoteAddAccount(),
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
