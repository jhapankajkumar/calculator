class SIPResultData {
  double corpus = 0;
  double totalInvestment = 0;
  double wealthGain = 0;
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
