import 'package:calculator/util/Components/radio_list.dart';

class SIPResult implements AbstractResult {
  double corpus = 0;
  double initialAmount = 0;
  double initialInterestRate = 0;
  double initialSteupRate = 0;
  double tenor = 0;
  double totalInvestment = 0;
  double wealthGain = 0;
}

class SWPResult implements AbstractResult {
  double totalInvestment = 0;
  double totalWithdrawal = 0;
  double totalProfit = 0;
  double returnRate = 0;
  double endBalance = 0;
  double withdrawalAmount = 0;
  double tenor = 0;
  Compounding compounding = Compounding.monthly;
}

class FutureValue implements AbstractResult {
  double investmentAmount = 0;
  double returnRate = 0;
  double totalProfit = 0;
  double corpus = 0;
  double tenor = 0;
  Compounding compounding = Compounding.monthly;
}

class EMIData implements AbstractResult {
  double loanAmount = 0;
  double interestRate = 0;
  double emiAmount = 0;
  int period = 0;
  List<InstalmentData> installments = [];
}

class InstalmentData {
  double principalAmount = 0;
  double interestAmount = 0;
  double remainingLoanBalance = 0;
  double emiAmount = 0;
  int tenor = 0;
}

abstract class AbstractResult {}

class SIPData implements AbstractData {
  int? tenor;
  double? amount;
  double? interest;
  double? totalBalance;
  double? startBalance;
}

abstract class AbstractData {}

class SWPData implements AbstractData {
  double? startBalance;
  double? withdrawal;
  double? interestEarned;
  double? endBalance;
  int? tenor;
}
