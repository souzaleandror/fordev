class RequiredFieldValidation {
  final String field;
  RequiredFieldValidation(this.field);
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatorio';
  }
}
