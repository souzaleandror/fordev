import 'package:fordev/main/composites/composites.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),

    /// COMMENT THIS BECAUSE PASSWORD DOESN'T HAVE VALIDATED YET
    //...ValidationBuilder.field('password').required().password().build(),
  ];
}
