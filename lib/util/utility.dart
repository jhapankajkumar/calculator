import 'dart:math';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,##,###");

class UtilityHelper {
  SIPResult getCorpusAmount(
      double amount, double interestRate, double period, double? stepUpRate) {
    SIPResult resultData = SIPResult();
    if (interestRate == 0) {
      resultData.totalInvestment = amount * period * 12;
      resultData.corpus = amount * period * 12;
      resultData.wealthGain = 0;
      return resultData;
    }
    var finalAmount = 0.0;
    var investAmount = 0.0;
    var interestAmount = 0.0;
    var sipAmount = amount;
    var totalInvestAmount = sipAmount;
    var s = (stepUpRate ?? 0) / 100;
    var n = period;
    var roi = (interestRate) / 100 / 12;
    var value3 = 1 + roi;
    var value4 = pow(value3, n);
    var finalValue = ((sipAmount) * value4);
    n = n - 1;
    while (n > 0) {
      if (n % 12 > 0) {
        sipAmount = sipAmount;
        totalInvestAmount = (totalInvestAmount) + (sipAmount);
        var value4 = pow(value3, n);
        finalValue = (finalValue + (sipAmount) * value4);
        n = n - 1;
      } else {
        sipAmount = (sipAmount) + ((sipAmount) * s);
        totalInvestAmount = (totalInvestAmount) + sipAmount;
        var value4 = pow(value3, n);
        finalValue = (finalValue + sipAmount * value4);
        n = n - 1;
      }
    }
    finalAmount = finalValue.roundToDouble();
    investAmount = (totalInvestAmount).roundToDouble();
    interestAmount = finalAmount - investAmount;
    interestAmount = interestAmount.roundToDouble();

    resultData.totalInvestment = investAmount;
    resultData.corpus = finalAmount;
    resultData.wealthGain = interestAmount;
    resultData.tenor = period;
    resultData.initialAmount = amount;
    resultData.initialInterestRate = interestRate;
    resultData.initialSteupRate = stepUpRate ?? 0;
    return resultData;
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

enum TextFieldFocus {
  investmentAmount,
  amount,
  period,
  months,
  interestRate,
  inflationrate,
  stepUp
}

String headerTitle(Screen category) {
  String headerTitle = "";
  switch (category) {
    case Screen.home:
      headerTitle = StringConstants.calculator;
      break;
    case Screen.sip:
      headerTitle = StringConstants.sipCalculator;
      break;
    case Screen.stepup:
      headerTitle = StringConstants.incrementalSIPCalculator;
      break;
    case Screen.lumpsum:
      headerTitle = StringConstants.lumpsumAmountCalculator;
      break;
    case Screen.swp:
      headerTitle = StringConstants.swpCalculator;
      break;
    case Screen.fd:
      headerTitle = StringConstants.fixedDepositCalculator;
      break;
    case Screen.rd:
      headerTitle = StringConstants.rdCalculator;
      break;
    case Screen.emi:
      headerTitle = StringConstants.emiCalcualtor;
      break;
    case Screen.fv:
      headerTitle = StringConstants.futureValueCalculator;
      break;
    case Screen.target:
      headerTitle = StringConstants.targetAmountCalculator;
      break;
    case Screen.retirement:
      headerTitle = StringConstants.retirementCalcualtor;
      break;
    default:
  }
  return headerTitle;
}

String amountTitle(Screen category) {
  String containerTitle = "";
  switch (category) {
    case Screen.sip:
    case Screen.stepup:
    case Screen.swp:
      containerTitle = StringConstants.monthlyWithdrawalAmount;
      break;
    case Screen.fd:
      containerTitle = StringConstants.fixedDepositAmount;
      break;
    case Screen.rd:
      containerTitle = StringConstants.recurringDepositAmount;
      break;
    case Screen.lumpsum:
      containerTitle = StringConstants.investmentAmount;
      break;
    case Screen.fv:
      containerTitle = StringConstants.startingAmount;
      break;
    case Screen.target:
      containerTitle = StringConstants.futureTargetAmout;
      break;
    case Screen.emi:
      containerTitle = StringConstants.loanAmount;
      break;
    default:
      print('default');
  }
  return containerTitle;
}

String periodTitle(Screen category) {
  String periodTitle = "";
  switch (category) {
    case Screen.sip:
    case Screen.swp:
      periodTitle = StringConstants.investmentPeriod;
      break;
    case Screen.stepup:
      periodTitle = StringConstants.investmentPeriodYears;
      break;
    case Screen.fd:
    case Screen.rd:
      periodTitle = StringConstants.depositPriod;
      break;
    case Screen.lumpsum:
      periodTitle = StringConstants.investmentPeriod;
      break;
    case Screen.fv:
      periodTitle = StringConstants.numberOfYears;
      break;
    case Screen.emi:
      periodTitle = StringConstants.loanPeriod;
      break;
    case Screen.target:
      periodTitle = StringConstants.futureAmountInvestmentPeriod;
      break;
    default:
      print('default');
  }
  return periodTitle;
}

String interestRateTitle(Screen category) {
  String interestRateTitle = "";
  switch (category) {
    case Screen.sip:
    case Screen.stepup:
      interestRateTitle = StringConstants.expectedReturn;
      break;
    case Screen.swp:
      interestRateTitle = StringConstants.expectedReturnsOnInvestment;
      break;
    case Screen.fd:
    case Screen.rd:
      interestRateTitle = StringConstants.rateOfInterest;
      break;
    case Screen.lumpsum:
      interestRateTitle = StringConstants.expectedReturn;
      break;
    case Screen.fv:
      interestRateTitle = StringConstants.interestRate;
      break;
    case Screen.emi:
      interestRateTitle = StringConstants.loanIntrestRate;
      break;
    case Screen.target:
      interestRateTitle = StringConstants.expectedReturnFuture;
      break;
    default:
      print('default');
  }
  return interestRateTitle;
}

String summaryExpectedAmountTitle(Screen category) {
  String summaryAmountTitle = "";
  switch (category) {
    case Screen.sip:
    case Screen.stepup:
    case Screen.swp:
    case Screen.lumpsum:
    case Screen.fd:
      summaryAmountTitle = StringConstants.expectedAmount;
      break;
    case Screen.fv:
      summaryAmountTitle = StringConstants.futureValueOfAmount;
      break;
    case Screen.rd:
      summaryAmountTitle = StringConstants.expectedAmount;
      break;
    case Screen.emi:
      summaryAmountTitle = StringConstants.loanEMI;
      break;
    case Screen.target:
      summaryAmountTitle = StringConstants.expectedAmount;
      break;
    default:
      print('default');
  }
  return summaryAmountTitle;
}

String summaryInvestedAmountTitle(Screen category) {
  String summaryAmountTitle = "";
  switch (category) {
    case Screen.sip:
    case Screen.stepup:
    case Screen.swp:
    case Screen.lumpsum:
    case Screen.fd:
      summaryAmountTitle = StringConstants.investedAmount;
      break;
    case Screen.rd:
      summaryAmountTitle = StringConstants.investedAmount;
      break;
    case Screen.fv:
      summaryAmountTitle = StringConstants.startingAmount;
      break;
    case Screen.emi:
      summaryAmountTitle = StringConstants.totalInterestPayable;
      break;
    case Screen.target:
      summaryAmountTitle = StringConstants.investedAmount;
      break;
    default:
      print('default');
  }
  return summaryAmountTitle;
}

String inflationRateTitle(Screen category) {
  return "";
}

// ignore: non_constant_identifier_names
String k_m_b_generator(double num) {
  if (num.isInfinite == true) {
    return "INFINITE";
  }
  if (num < 999999999999999) {
    return "${formatter.format(num)}";
  } else {
    return num.roundToDouble().toString();
  }
}

Widget messageView(String message) {
  return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.accentColor, width: 1.0),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[80]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: subTitle1,
        ),
      ));
}
