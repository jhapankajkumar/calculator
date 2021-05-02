import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestmentDetail extends StatefulWidget {
  final SIPData data;
  InvestmentDetail(this.data);
  @override
  _InvestmentDetailState createState() => _InvestmentDetailState();
}

class _InvestmentDetailState extends State<InvestmentDetail> {
  final formatter = new NumberFormat("##,###");
  List<SIPData>? list;
  @override
  void initState() {
    list = getInvestmentValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Investment Detail"),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: <Widget>[
                Card(
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(
                          child: Text(
                            "Duration",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text("SIP Amount",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Center(
                          child: Text(
                            "Future Value",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (list != null) {
                          SIPData data = list![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: index == 0
                                      ? Colors.blue[300]
                                      : (index % 2 == 0
                                          ? Colors.grey[300]
                                          : Colors.white)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                          "${(data.duration?.toInt())} Years"),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "\$${data.amount?.toInt() ?? 0}"),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: 300,
                                      child: Text(
                                        '\$${k_m_b_generator(data.futureValue ?? 0)}',
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      itemCount: 35),
                ),
              ],
            )));
  }

  List<SIPData> getInvestmentValues() {
    var helper = UtilityHelper();
    var limit = 35;
    double amount = helper.getFutureAmountValue(
        widget.data.amount ?? 0,
        widget.data.interestRate ?? 0,
        (widget.data.duration ?? 0),
        null,
        false,
        false);
    SIPData data = SIPData(
        amount: widget.data.amount,
        duration: (widget.data.duration ?? 0),
        increase: 2,
        futureValue: amount);
    var list = List.generate(limit - 1, (index) {
      double amount = helper
          .getFutureAmountValue(widget.data.amount ?? 0,
              widget.data.interestRate ?? 0, index + 1, null, false, false)
          .roundToDouble();
      // investedAmount = (amount ?? 0) * (period ?? 0) * 12;
      // wealthGain = (corpusAmount ?? 0) - (investedAmount ?? 0);
      return SIPData(
          amount: widget.data.amount,
          duration: index + 1,
          increase: 2,
          futureValue: amount.roundToDouble());
    });

    // list.insert(0, list[widget.data.duration?.toInt() ?? 0 - 1]);
    // list.remove(list[widget.data.duration?.toInt() ?? 0 - 1]);
    list.insert(0, data);
    return list;
  }

  // ignore: non_constant_identifier_names
  String k_m_b_generator(double num) {
    if (num.isInfinite == true) {
      return "INFINITE";
    }
    if (num < 999999999999999999) {
      return "${formatter.format(num)}";
    } else {
      return num.roundToDouble().toString();
    }
  }
}
