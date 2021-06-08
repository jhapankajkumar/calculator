class SIPResultData {
  double corpus = 0;
  double totalInvestment = 0;
  double wealthGain = 0;
  double tenor = 0;
  double initialAmount = 0;
  double initialInterestRate = 0;
  double initialSteupRate = 0;
  List<SIPData>? list;
}

class SIPData {
  int? tenor;
  double? amount;
  double? interest;
  double? totalBalance;
  bool isExpanded = false;
  List<SIPData>? list;
}
