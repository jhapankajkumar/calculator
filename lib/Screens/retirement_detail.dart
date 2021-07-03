import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Constants/constants.dart';
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
  Widget buildDetail(
      String title, double value, bool? isPeriod, bool isDevider) {
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
          isDevider == true
              ? Container(
                  height: 1,
                  color: Colors.grey,
                )
              : Container(),
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
                    buildHeader("AMOUNT YOU NEED FOR RETIREMENT",
                        widget.result.finalRetirementAmount),
                    // Container(
                    //   color: appTheme.accentColor,
                    //   padding: EdgeInsets.all(8),
                    //   child: Text(
                    //     'Break Down',
                    //     style: appTheme.textTheme.bodyText1,
                    //   ),
                    // ),
                    buildDetail('YOUR CURRENT MONTHLY HOUSEHOLD EXPENSES',
                        widget.result.currentExpenses, false, true),
                    buildDetail(
                        'YOUR FUTURE MONTHLY HOUSEHOLD EXPENSES (INFLATION ADJUSTED)',
                        widget.result.futureExpenses,
                        false,
                        true),
                    buildDetail(
                        'AMOUNT YOU REQUIRED TO MEET EXPENSES ON RETIRMENT ${widget.result.currentInvestmentAmount > 0 ? '(A)' : ''}',
                        widget.result.corpusAmount,
                        false,
                        true),
                    widget.result.currentInvestmentAmount > 0
                        ? buildDetail('YOUR CURRENT INVESTMENT AMOUNT',
                            widget.result.currentInvestmentAmount, false, true)
                        : Container(),
                    widget.result.currentInvestmentAmount > 0
                        ? buildDetail(
                            'FUTURE VALUE OF YOUR CURRENT INVESTMENTS AFTER ${widget.result.period.toInt()} YEARS (B)',
                            widget.result.futureInvestmentsAmount,
                            false,
                            true)
                        : Container(),

                    widget.result.currentInvestmentAmount > 0
                        ? buildDetail(
                            'FINAL AMOUNT YOU NEED FOR RETIREMENT \n(A - B)',
                            widget.result.finalRetirementAmount,
                            false,
                            true)
                        : Container(),
                    buildDetail('NUMBER OF YEARS YOU NEED TO INVEST',
                        widget.result.period.toDouble(), true, true),
                    buildDetail('LUMPSUM AMOUNT YOU NEED TO INVEST',
                        widget.result.lumpsumAmount, false, true),
                    buildDetail('SIP AMOUNT YOU NEED TO INVEST',
                        widget.result.sipAmount, false, false),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ))));
  }
}
