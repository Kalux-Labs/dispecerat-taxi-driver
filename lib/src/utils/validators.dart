class Validators {
  static String? phoneValidator(String? value) {
    final regex = RegExp(r'^\d{3} \d{3} \d{3}$');
    if(value == null || !regex.hasMatch(value)) {
      return 'Numarul nu este valid';
    }
    return null;
  }
}
