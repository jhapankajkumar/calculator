import 'dart:math';

import 'package:calculator/util/Components/Charts/chart_helper.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../indicator.dart';

class BarChartView extends StatefulWidget {
  final InvestmentResult data;
  final int barCount;
  final Screen cateogry;
  const BarChartView(
      {Key? key,
      required this.data,
      required this.barCount,
      required this.cateogry})
      : super(key: key);

  @override
  _BarChartViewState createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int interval = 0;
  double amountInterval = 0;

  @override
  void initState() {
    super.initState();
  }

  List<BarChartGroupData>? getGroupDataList() {
    List<BarChartGroupData> groupList = [];
    List<double>? finalBalancelist = ChartHelper.shared.getPointSpots(
        SpotsType.balance, interval, amountInterval, widget.data);
    List<double>? withdrawalList = ChartHelper.shared.getPointSpots(
        SpotsType.withdrawal, interval, amountInterval, widget.data);
    List<double>? profitList = ChartHelper.shared.getPointSpots(
        SpotsType.interest, interval, amountInterval, widget.data);
    List<double>? startBalanceList = ChartHelper.shared
        .getPointSpots(SpotsType.amount, interval, amountInterval, widget.data);

    int i = 0;
    finalBalancelist?.forEach((element) {
      var barGroup1 = ChartHelper.shared.makeGroupData(
        i,
        startBalanceList?[i] ?? 0,
        element,
        withdrawalList?[i] ?? 0,
        profitList?[i] ?? 0,
      );
      i = i + 1;
      groupList.add(barGroup1);
    });
    return groupList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.finalBalance.toString().length > 16) {
      return Text('Data is too larget to fit in chart');
    }
    return Container(
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      height: MediaQuery.of(context).size.width + 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        gradient: LinearGradient(
          colors: [
            Color(0xff2c274c),
            appTheme.accentColor,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                widget.cateogry == Screen.swp
                    ? "Balance Left"
                    : "Total Expected Amount",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: subTtitleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '\$ ${formatter.format(widget.data.finalBalance)}',
                style: TextStyle(
                    color: ternaryColor,
                    fontSize: subTtitleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Indicator(
                        color: ChartHelper.shared.startBalanceColor,
                        size: indicatorSize,
                        text: "Start Balance",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: ChartHelper.shared.finalBalanceColor,
                        size: indicatorSize,
                        text: "Final Balance",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: ChartHelper.shared.withdrawalColor,
                        size: indicatorSize,
                        text: "Amount Withdrawal",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: ChartHelper.shared.interestEarnedColor,
                        size: indicatorSize,
                        text: "Interest Earned",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: BarChart(getBarChartData()),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Duration in Years ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getMaxValue() {
    return max(max(widget.data.totalProfit, widget.data.totalWithdrawal),
        max(widget.data.totalInvestedAmount, widget.data.finalBalance));
  }

  BarChartData getBarChartData() {
    interval = ChartHelper.shared
        .getTimeInterval(widget.data.tenor, 12, widget.cateogry);
    amountInterval = ChartHelper.shared.getAmountInterval(getMaxValue());
    return BarChartData(
      maxY: 5,
      minY: 0,
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Color(0xff2c274c),
            getTooltipItem: (_a, _b, _c, _d) {
              return ChartHelper.shared
                  .getBarChartGroupTouchData(_a, widget.data, interval);
            },
          ),
          touchCallback: (response) {}),
      titlesData: FlTitlesData(
          bottomTitles:
              ChartHelper.shared.getBottomTiles(interval, widget.cateogry, 12),
          leftTitles:
              ChartHelper.shared.getLeftSideTiles(amountInterval, false),
          rightTitles: ChartHelper.shared.getRightSideTiles()),
      gridData: FlGridData(
        show: true,
      ),
      borderData: ChartHelper.shared.getChartBorder(true),
      barGroups: getGroupDataList(),
    );
  }
}
