class InvestmentResult {
  double finalBalance = 0;
  double totalProfit = 0;
  double totalInvestedAmount = 0;
  double totalWithdrawal = 0;
  int tenor = 0;
  List<InvestmentData>? list;
}

class InvestmentData {
  double balance = 0; // end amount
  double profit = 0; // interest
  double amount = 0;
  double cumulatveProfit = 0;
  double cumulatveWithdrawal = 0;
  // start amount
  double? withdrawal; // withdrawal for SWP
  int tenor = 0;
}
