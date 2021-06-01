import 'package:flutter/services.dart';

String regexSource = "^\$|^(0|([1-9][0-9]{0,15}))(\\.[0-9]{0,2})?\$";

class InputFormatterValidator implements TextInputFormatter {
  final RegexValidator validator;
  InputFormatterValidator({required this.validator});
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var isOldValueValid = validator.isValid(oldValue.text);
    var isNewValueValid = validator.isValid(newValue.text);
    if (isOldValueValid && !isNewValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class RegexValidator {
  final String source;
  RegexValidator({required this.source});
  bool isValid(String value) {
    try {
      var regex = RegExp(source);
      var matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
    } catch (error) {}

    return false;
  }
}
