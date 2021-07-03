import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/retirement_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';

class RetirementCalulationResult extends StatefulWidget {
  final Screen category;
  final RetirementResult result;
  const RetirementCalulationResult(
      {Key? key, required this.category, required this.result})
      : super(key: key);

  @override
  _RetirementCalulationResultState createState() =>
      _RetirementCalulationResultState();
}

class _RetirementCalulationResultState
    extends State<RetirementCalulationResult> {
  Widget buildDetail(String title, double value, bool? isPeriod) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              isPeriod == true
                  ? '${formatter.format(value)} Years'
                  : '\$ ${formatter.format(value)}',
              textAlign: TextAlign.center,
              style: subTitle1,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buildHeader(String title, double value) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: subTitle2,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              '\$ ${formatter.format(value)}',
              textAlign: TextAlign.center,
              style: headerValueStyle,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(category: Screen.retirementResult, context: context),
        body: baseContainer(
            context: context,
            onTap: null,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //current expenses
                    SizedBox(
                      height: 10,
                    ),
                    buildHeader("AMOUNT NEEDED FOR RETIREMENT",
                        widget.result.finalRetirementAmount),
                    buildDetail('YOUR CURRENT MONTHLY EXPENSE',
                        widget.result.currentExpenses, false),
                    buildDetail(
                        'YOUR FUTURE MONTHLY EXPENSES INCLUDING INFLATION',
                        widget.result.futureExpenses,
                        false),
                    buildDetail('YOUR CURRENT INVESTMENT AMOUNT',
                        widget.result.currentInvestmentAmount, false),
                    buildDetail('FUTURE VALUE OF INVESTMENT AMOUNT',
                        widget.result.futureInvestmentsAmount, false),
                    buildDetail(
                        'RETIREMENT CORPUS', widget.result.corpusAmount, false),
                    widget.result.currentInvestmentAmount > 0
                        ? buildDetail(
                            'FINAL AMOUNT (RETIREMENT CORPUS - FUTURE INVESTMENT)',
                            widget.result.finalRetirementAmount,
                            false)
                        : Container(),
                    buildDetail('NUMBER OF YEARS YOU NEED TO INVEST',
                        widget.result.period.toDouble(), true),
                    buildDetail('LUMPSUM AMOUNT YOU NEED TO INVEST',
                        widget.result.lumpsumAmount, false),
                    buildDetail('SIP AMOUNT YOU NEED TO INVEST',
                        widget.result.sipAmount, false),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ))));
  }
}
