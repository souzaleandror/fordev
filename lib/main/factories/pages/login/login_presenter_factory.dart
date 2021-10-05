import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/main/factories/usecases/save_current_account_factory.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/presentation/presenters/presenters.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
