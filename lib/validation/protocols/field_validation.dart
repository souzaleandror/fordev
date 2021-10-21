import 'package:fordev/ui/presentation/protocols/protocols.dart';

abstract class FieldValidation {
  String get field;
  ValidationError validate(Map input);
}
