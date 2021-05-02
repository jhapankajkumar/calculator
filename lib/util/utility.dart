import 'dart:math';

class UtilityHelper {
  double getFutureAmountValue(double amount, double interestRate, double period,
      double? inflationRate, bool isMonthlyInvestment, bool adjustInflation) {
    if (adjustInflation && inflationRate != null) {
      interestRate = interestRate - inflationRate;
    }
    if (isMonthlyInvestment) {
      period = period / 12;
    }
    if (interestRate == 0) {
      return amount * period * 12;
    }
    
    double roi = interestRate / 100 / 12;
    num power = pow(1 + roi, 12 * (period));
    double value = (((power - 1) * (amount)) / roi) * (1 + roi);
    // print('Expected Amount $value');
    print('\n');
    return value;
  }
}

enum TextFieldFocus { amount, period, interestRate, inflationrate }
