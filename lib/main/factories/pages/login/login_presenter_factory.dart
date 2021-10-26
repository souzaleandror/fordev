import '../../../../main/factories/factories.dart';
import '../../../../main/factories/usecases/save_current_account_factory.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../ui/presentation/presenters/presenters.dart';

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
