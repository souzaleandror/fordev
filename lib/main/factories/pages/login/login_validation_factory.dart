import 'package:fordev/main/builders/builders.dart';
import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),

    /// COMMENT THIS BECAUSE PASSWORD DOESN'T HAVE VALIDATED YET
    //...ValidationBuilder.field('password').required().password().build(),
    ...ValidationBuilder.field('password').required().build(),
  ];
}
