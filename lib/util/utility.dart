import 'dart:math';

class UtilityHelper {
  double getCorpusAmount(double amount, double interestRate, double period,
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

    return value;
  }

  double getSIPAmount(double amount, double interestRate, double period,
      double? inflationRate, bool isMonthlyInvestment, bool adjustInflation) {
    if (adjustInflation && inflationRate != null) {
      interestRate = interestRate - inflationRate;
    }
    if (isMonthlyInvestment) {
      period = period / 12;
    }
    if (interestRate == 0) {
      return amount / period / 12;
    }

    double roi = interestRate / 100 / 12;
    num power = pow(1 + roi, 12 * (period));
    double sipAmount =
        ((amount * roi) / ((1 + roi) * (power - 1))).roundToDouble();
    double value = (((power - 1) * (sipAmount)) / roi) * (1 + roi);
    print(sipAmount);
    print(value);
    return sipAmount;
  }

  double getFutureValueAmount(
      double amount, double interestRate, double period, int compounding) {
    if (interestRate == 0) {
      return amount * period * 12;
    }

    double roi = interestRate / 100 / compounding;
    num power = pow(1 + roi, compounding * (period));
    double value = amount * power;
    return value;
  }

  double getInstallmentAmount(double amount, double period, double rate) {
    double fVal = 0;
    double pVal = amount;
    double nper = period;
    if (rate > 0) {
      rate = rate / 100 / 12;
      var aVal = rate * pVal * pow((1 + rate), nper);
      var bVal = pow((1 + rate), nper) - 1;
      var rVal = aVal / bVal;
      return rVal.roundToDouble();
    } else {
      var val = ((pVal + fVal) / nper);
      var result = ((-val * 100).round()) / 100;
      return result.roundToDouble();
    }
  }
}

enum TextFieldFocus { amount, period, interestRate, inflationrate, stepUp }
