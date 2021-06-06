import 'dart:math';

import 'package:calculator/util/sip_data.dart';
import 'package:flutter/services.dart';

class UtilityHelper {
  SIPResultData getCorpusAmount(
      double amount, double interestRate, double period, double? stepUpRate) {
    SIPResultData resultData = SIPResultData();
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
    var n = period * 12;
    var roi = (interestRate) / 100 / 12;
    var value3 = 1 + roi;
    var value4 = pow(value3, n);
    var finalValue = ((sipAmount) * value4);
    int tenor = 1;
    int year = 1;
    //list by year
    List<SIPData> yearList = [];

    //create first year data
    List<SIPData> monthList = [];
    //create 1st month wise data;
    SIPData monthData = SIPData();
    monthData.amount = amount.roundToDouble();
    monthData.totalBalance = finalValue.roundToDouble();
    monthData.interest = (finalValue - (amount)).roundToDouble();
    monthData.tenor = tenor;

    monthList.add(monthData);
    n = n - 1;
    tenor = 2;

    while (n > 0) {
      if (n % 12 > 0) {
        sipAmount = sipAmount;
        totalInvestAmount = (totalInvestAmount) + (sipAmount);
        var value4 = pow(value3, n);
        finalValue = (finalValue + (sipAmount) * value4);

        SIPData monthData = SIPData();
        monthData.amount = (amount * tenor).roundToDouble();
        monthData.totalBalance = finalValue.roundToDouble();
        monthData.interest =
            (monthData.totalBalance ?? 0) - (monthData.amount ?? 0);
        monthData.tenor = tenor;
        monthList.add(monthData);
        n = n - 1;

        //if year complete
        if (n % 12 == 0) {
          SIPData yearData = SIPData();
          yearData.tenor = tenor ~/ 12;
          yearData.amount = monthData.amount;
          yearData.totalBalance = monthData.totalBalance;
          yearData.interest = monthData.interest;
          yearData.list = monthList;

          yearList.add(yearData);

          monthList = [];
        }
        tenor = tenor + 1;
      } else {
        sipAmount = (sipAmount) + ((sipAmount) * s);
        totalInvestAmount = (totalInvestAmount) + sipAmount;
        var value4 = pow(value3, n);
        finalValue = (finalValue + sipAmount * value4);

        SIPData monthData = SIPData();
        monthData.amount = (amount * tenor).roundToDouble();
        monthData.totalBalance = finalValue.roundToDouble();
        monthData.interest =
            (monthData.totalBalance ?? 0) - (monthData.amount ?? 0);
        monthData.tenor = tenor;
        monthList.add(monthData);
        n = n - 1;
        tenor = tenor + 1;
      }
    }
    finalAmount = finalValue.roundToDouble();
    investAmount = (totalInvestAmount).roundToDouble();
    interestAmount = finalAmount - investAmount;
    interestAmount = interestAmount.roundToDouble();

    resultData.totalInvestment = investAmount;
    resultData.corpus = finalAmount;
    resultData.wealthGain = interestAmount;
    resultData.list = yearList;
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

enum TextFieldFocus { amount, period, interestRate, inflationrate, stepUp }
