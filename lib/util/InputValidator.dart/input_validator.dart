import 'package:flutter/services.dart';

String regexSource = "^\$|^(0|([1-9][0-9]{0,15}))(\\[0-9]{0,2})?\$";
String decimalRegex = "^\$|^(0|([1-9][0-9]{0,2}))(\\.[0-9]{0,2})?\$";

class InputFormatterValidator implements TextInputFormatter {
  final AmountValidator validator;
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

abstract class AmountValidator {
  bool isValid(String value);
}

class AmountRegexValidator extends AmountValidator {
  final String source;
  AmountRegexValidator({required this.source});
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

class DecimalRegexValidator extends AmountValidator {
  final String source;
  DecimalRegexValidator({required this.source});
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
