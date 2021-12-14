import 'package:fordev/ui/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidationSpy extends Mock implements FieldValidation {
  FieldValidationSpy() {
    this.mockValidation();
    this.mockFieldName('any_field');
  }
  When mockValidationCall() => when(() => this.validate(any()));
  void mockValidation() => this.mockValidationCall().thenReturn(null);
  void mockValidationError(ValidationError error) =>
      this.mockValidationCall().thenReturn(error);

  void mockFieldName(String fieldName) =>
      when(() => this.field).thenReturn(fieldName);

  void mockValidation2(ValidationError? error) {
    when(() => this.validate(any())).thenReturn(error);
  }

  void mockValidation3(ValidationError? error) {
    when(() => this.validate(any())).thenReturn(error);
  }
}
