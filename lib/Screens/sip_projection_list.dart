import 'dart:math';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SIPProjetionList extends StatefulWidget {
  final SIPData data;
  SIPProjetionList(this.data);
  @override
  _SIPProjetionListState createState() => _SIPProjetionListState();
}

class _SIPProjetionListState extends State<SIPProjetionList> {
  final formatter = new NumberFormat("##,###");
  List<SIPData>? list;
  @override
  void initState() {
    list = widget.data.increase == null
        ? getInvestmentValues()
        : getStepUpInvestmentValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Investment Detail", context: context),
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(
                              "Duration",
                              style: subTitle1,
                            ),
                          ),
                        ),
                        Center(
                          child: Text("SIP Amount", style: subTitle1),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Text(
                              "Future Value",
                              style: subTitle1,
                            ),
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
                                      ? appTheme.secondaryHeaderColor
                                      : (index % 2 == 0
                                          ? appTheme.primaryColor
                                          : Colors.white)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        "${(data.duration?.toInt())} Years",
                                        style: subTitle1,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Text(
                                          "\$${data.amount?.toInt() ?? 0}",
                                          style: subTitle2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Text(
                                        '\$${k_m_b_generator(data.futureValue ?? 0)}',
                                        overflow: TextOverflow.fade,
                                        style: subTitle2,
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
    double amount = helper.getCorpusAmount(
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
          .getCorpusAmount(widget.data.amount ?? 0,
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

  List<SIPData> getStepUpInvestmentValues() {
    var amount = widget.data.amount;
    var limit = 35;
    double? stepupFinalAmount = getSipAmount(widget.data.duration);
    SIPData data = SIPData(
        amount: amount,
        duration: (widget.data.duration ?? 0),
        increase: 2,
        futureValue: stepupFinalAmount);
    var list = List.generate(limit - 1, (index) {
      double? stepupFinalAmount = getSipAmount((index + 1).toDouble());
      if (index != 0) {
        amount =
            (amount ?? 0) + ((amount ?? 0) * (widget.data.increase ?? 0) / 100);
      }
      return SIPData(
          amount: amount,
          duration: index + 1,
          increase: 2,
          futureValue: stepupFinalAmount);
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
    if (num < 9999999999) {
      return "${formatter.format(num)}";
    } else {
      return num.roundToDouble().toString();
    }
  }

  double? getSipAmount(double? duration) {
    var stepupFinalAmount = 0.0;
    var sipAmount = widget.data.amount;
    var totalInvestAmount = sipAmount;
    var s = (widget.data.increase ?? 0) / 100;
    var n = (duration ?? 0) * 12;
    var roi = (widget.data.interestRate ?? 0) / 100 / 12;
    var value3 = 1 + roi;
    var value4 = pow(value3, n);
    var finalValue = (sipAmount ?? 0) * value4;
    n = n - 1;
    while (n > 0) {
      if (n % 12 > 0) {
        sipAmount = sipAmount;
        totalInvestAmount = (totalInvestAmount ?? 0) + (sipAmount ?? 0);
        var value4 = pow(value3, n);
        finalValue = finalValue + (sipAmount ?? 0) * value4;
        n = n - 1;
      } else {
        sipAmount = (sipAmount ?? 0) + ((sipAmount ?? 0) * s);
        totalInvestAmount = (totalInvestAmount ?? 0) + sipAmount;
        var value4 = pow(value3, n);
        finalValue = finalValue + sipAmount * value4;
        n = n - 1;
      }
    }
    stepupFinalAmount = finalValue.roundToDouble();
    return stepupFinalAmount;
  }
}
