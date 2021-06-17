import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/bar_chart.dart';
import 'package:calculator/util/Components/line_chart.dart';

import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/investment_detail_table.dart';
import 'package:calculator/util/Components/pdf_table.dart';
import 'package:calculator/util/Components/radio_list.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SIPProjetionList extends StatefulWidget {
  final AbstractResult data;
  final Screen category;
  SIPProjetionList({required this.category, required this.data});
  @override
  _SIPProjetionListState createState() => _SIPProjetionListState();
}

class _SIPProjetionListState extends State<SIPProjetionList> {
  int _currentSelection = 0;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? chartImage;
  late InvestmentResult result;
  @override
  void initState() {
    super.initState();
    result = InvestmentResult();
    fillAmount(context, widget.category);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      deletePreviousData();
    });
  }

  void fillAmount(BuildContext context, Screen category) {
    switch (widget.data.runtimeType) {
      case FutureValue:
        FutureValue fValue = widget.data as FutureValue;
        result.finalBalance = fValue.corpus;
        result.tenor = fValue.tenor.toInt();
        result.totalProfit = fValue.totalProfit;
        result.totalInvestedAmount = fValue.investmentAmount;

        List<InvestmentData> list = [];
        double sipAmount = fValue.investmentAmount;
        double steupAmount = 0;
        double counter = 1;
        var helper = UtilityHelper();
        var compoundedValue = 4;
        if (fValue.compounding == Compounding.annually) {
          compoundedValue = 1;
        } else if (fValue.compounding == Compounding.monthly) {
          compoundedValue = 12;
        }
        for (int i = 1; i <= fValue.tenor; i++) {
          InvestmentData sipData = InvestmentData();
          sipData.tenor = i;
          double amount = 0;
          double corpus = helper
              .getFutureValueAmount(fValue.investmentAmount, fValue.returnRate,
                  i.toDouble(), compoundedValue)
              .roundToDouble();
          amount = fValue.investmentAmount;
          counter = counter + 1;

          double? interest = corpus - amount;
          sipData.balance = corpus;
          sipData.amount = amount;
          sipData.profit = interest;
          list.add(sipData);
        }
        result.list = list;

        break;
      case SIPResult:
        SIPResult sipResult = widget.data as SIPResult;
        result.finalBalance = sipResult.corpus;
        result.tenor = sipResult.tenor.toInt();
        result.totalProfit = sipResult.wealthGain;
        result.totalInvestedAmount = sipResult.totalInvestment;

        List<InvestmentData> list = [];
        double sipAmount = sipResult.initialAmount;
        double steupAmount = 0;
        double counter = 1;
        for (int i = 1; i <= sipResult.tenor; i++) {
          InvestmentData sipData = InvestmentData();
          sipData.tenor = i;
          double amount = 0;
          double corpus = getSipAmount(i.toDouble(), sipResult) ?? 0;
          amount = (sipAmount * i) + (steupAmount * counter);
          counter = counter + 1;
          if (i % 12 == 0) {
            counter = 1;
            steupAmount = sipAmount * sipResult.initialSteupRate / 100;
          }

          double? interest = corpus - amount;
          sipData.balance = corpus;
          sipData.amount = amount;
          sipData.profit = interest;
          list.add(sipData);
        }
        result.list = list;

        break;
      case SWPResult:
        SWPResult swpResult = widget.data as SWPResult;
        result.finalBalance = swpResult.endBalance;
        result.tenor = swpResult.tenor.toInt() * 12;
        result.totalProfit = swpResult.totalProfit;
        result.totalInvestedAmount = swpResult.totalInvestment;
        result.totalWithdrawal = swpResult.totalWithdrawal;

        double tempEndAmount = swpResult.totalInvestment;
        double tempTotalWithdrawal = 0;
        double tempTotalProfit = 0;
        double withdrawalPeriod = 12;
        if (swpResult.compounding == Compounding.annually) {
          withdrawalPeriod = 1;
        } else if (swpResult.compounding == Compounding.quaterly) {
          withdrawalPeriod = 4;
        }
        double roi = (swpResult.returnRate / 100) / withdrawalPeriod;
        // result = SIPResultData();
        List<InvestmentData> list = [];
        for (int i = 1; i <= withdrawalPeriod * swpResult.tenor; i++) {
          // Data data = Data();
          //data.startBalance = totalInvestmentAmount;
          InvestmentData swpData = InvestmentData();
          swpData.tenor = i;
          swpData.amount = tempEndAmount;

          //withdraw money
          tempEndAmount = tempEndAmount - swpResult.withdrawalAmount;

          swpData.withdrawal = swpResult.withdrawalAmount;
          // data.amount = amount;
          tempTotalWithdrawal =
              tempTotalWithdrawal + swpResult.withdrawalAmount;
          swpData.cumulatveWithdrawal = tempTotalWithdrawal;
          double profit = tempEndAmount * roi;

          swpData.profit = profit;
          //data.in
          tempTotalProfit = tempTotalProfit + profit;
          swpData.cumulatveProfit = tempTotalProfit;
          //add interest
          tempEndAmount = tempEndAmount + profit.round();

          swpData.balance = tempEndAmount;
          list.add(swpData);

          if (tempEndAmount - swpResult.withdrawalAmount < 0) {
            print("Exit At $i");
            result.tenor = i; //swpResult.tenor.toInt();
            break;
          }
        }

        result.list = list;

        break;
    }
  }

  Future<void> deletePreviousData() async {
    var directory = await getApplicationDocumentsDirectory();
    var pngFile = File('${directory.path}/chart.png');
    var doesFileExist = await pngFile.exists();

    if (doesFileExist) {
      pngFile.delete();
    }

    var pdfFile = File('${directory.path}/GrowFundCalculator.pdf');
    doesFileExist = await pdfFile.exists();
    if (doesFileExist) {
      pdfFile.delete();
    }
  }

  Future<void> takeScreenShot() async {
    var directory = await getApplicationDocumentsDirectory();
    screenshotController.capture().then((Uint8List? image) async {
      setState(() async {
        if (image != null) {
          chartImage = image;
          var file = File('${directory.path}/chart');
          file.writeAsBytes(chartImage!);
        } else if (chartImage != null) {
          var file = File('${directory.path}/chart');
          file.writeAsBytes(chartImage!);
        }
        createPDF(context, result, widget.category);
      });
    }).catchError((onError) {
      if (chartImage != null) {
        var file = File('${directory.path}/chart');
        file.writeAsBytes(chartImage!);
      }
      createPDF(context, result, widget.category);
    });
  }

  void onTapShareButton() {
    takeScreenShot().then((value) async {
      final box = context.findRenderObject() as RenderBox?;
      var directory = await getApplicationDocumentsDirectory();
      var imagePath = '${directory.path}/GrowFundCalculator.pdf';
      if (imagePath.isNotEmpty) {
        await Share.shareFiles([imagePath],
            text: "GrowFund",
            subject: "Investment Detail",
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      } else {
        await Share.share("text",
            subject: "subject",
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      }
    }).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            category: widget.category,
            context: context,
            isTrailing: true,
            onTapShare: onTapShareButton),
        body: baseContainer(
            context: context,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialSegmentedControl(
                    children: {
                      0: Text(
                        '          Table          ',
                        style: TextStyle(
                            color: (this._currentSelection == 0
                                ? Colors.white
                                : appTheme.accentColor)),
                      ),
                      1: Text(
                        '          Chart          ',
                        style: TextStyle(
                            color: (this._currentSelection == 1
                                ? Colors.white
                                : appTheme.accentColor)),
                      ),
                    },
                    selectionIndex: _currentSelection,
                    borderColor: appTheme.primaryColor,
                    selectedColor: appTheme.accentColor,
                    unselectedColor: appTheme.primaryColor,
                    horizontalPadding: EdgeInsets.all(16),
                    verticalOffset: 16,
                    borderRadius: 32.0,
                    disabledColor: appTheme.primaryColor,
                    onSegmentChosen: (int index) {
                      setState(() {
                        _currentSelection = index;
                      });
                    },
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  _currentSelection == 0
                      ? Expanded(
                          child: InvestmentListTableView(
                              data: result, category: widget.category))
                      : Expanded(
                          child: Screenshot(
                              controller: screenshotController,
                              child: widget.category == Screen.swp
                                  ? BarChartView(
                                      data: result,
                                      barCount: 3,
                                      cateogry: widget.category,
                                    )
                                  : LineChartView(
                                      data: result,
                                      barCount: 3,
                                      cateogry: widget.category,
                                    ))),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )));
  }

  double? getSipAmount(double? duration, SIPResult data) {
    var stepupFinalAmount = 0.0;
    var sipAmount = data.initialAmount;
    var totalInvestAmount = sipAmount;
    var s = (data.initialSteupRate) / 100;
    var n = (duration ?? 0);
    var roi = (data.initialInterestRate) / 100 / 12;
    var value3 = 1 + roi;
    var value4 = pow(value3, n);
    var finalValue = (sipAmount) * value4;
    n = n - 1;
    while (n > 0) {
      if (n % 12 > 0) {
        sipAmount = sipAmount;
        totalInvestAmount = (totalInvestAmount) + (sipAmount);
        var value4 = pow(value3, n);
        finalValue = finalValue + (sipAmount) * value4;
        n = n - 1;
      } else {
        sipAmount = (sipAmount) + ((sipAmount) * s);
        totalInvestAmount = (totalInvestAmount) + sipAmount;
        var value4 = pow(value3, n);
        finalValue = finalValue + sipAmount * value4;
        n = n - 1;
      }
    }
    stepupFinalAmount = finalValue.roundToDouble();
    return stepupFinalAmount;
  }
}
