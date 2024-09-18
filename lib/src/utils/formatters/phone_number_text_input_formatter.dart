import 'package:flutter/services.dart';

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final String newText = newValue.text;

    // Insert spaces at the appropriate positions
    if (newText.length > 3 && newText.length <= 6) {
      return TextEditingValue(
        text: '${newText.substring(0, 3)} ${newText.substring(3)}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: newValue.selection.end + 1),
        ),
      );
    } else if (newText.length > 6) {
      return TextEditingValue(
        text: '${newText.substring(0, 3)} ${newText.substring(3, 6)} ${newText.substring(6)}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: newValue.selection.end + 2),
        ),
      );
    }
    return newValue;
  }
}
