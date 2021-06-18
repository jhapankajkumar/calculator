import 'dart:math';

import 'package:calculator/util/Components/Charts/chart_helper.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../indicator.dart';

class LineChartView extends StatefulWidget {
  final InvestmentResult data;
  final int barCount;
  final Screen cateogry;
  const LineChartView(
      {Key? key,
      required this.data,
      required this.barCount,
      required this.cateogry})
      : super(key: key);

  @override
  _LineChartViewState createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  int deltaFactor = 12;
  bool isFutureValue = false;
  int interval = 0;
  double amountInterval = 0;
  @override
  void initState() {
    if (widget.cateogry == Screen.fd ||
        widget.cateogry == Screen.fv ||
        widget.cateogry == Screen.lumpsum) {
      isFutureValue = true;
      deltaFactor = 1;
    } else {
      isFutureValue = false;
    }
    super.initState();
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
                "Total Expected Amount",
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
                        color: Colors.green,
                        size: indicatorSize,
                        text: isFutureValue ? 'End Balance' : "Total Amount",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: Colors.red,
                        size: indicatorSize,
                        text:
                            isFutureValue ? 'Start Balance' : "Invested Amount",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: Colors.yellow,
                        size: indicatorSize,
                        text: "Wealth Gain",
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
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: LineChart(
                    getLineChartData(),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                  ),
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

  List<LineChartBarData> linesBarDetails() {
    return [
      ChartHelper.shared.getLineSpotsData(SpotsType.interest, interval,
          amountInterval, widget.data, Colors.yellow),
      ChartHelper.shared.getLineSpotsData(SpotsType.balance, interval,
          amountInterval, widget.data, Colors.green),
      ChartHelper.shared.getLineSpotsData(
          SpotsType.amount, interval, amountInterval, widget.data, Colors.red),
    ];
  }

  LineChartData getLineChartData() {
    interval = ChartHelper.shared
        .getTimeInterval(widget.data.tenor, deltaFactor, widget.cateogry);
    // print('Year Interval, $interval');
    amountInterval =
        ChartHelper.shared.getAmountInterval(widget.data.finalBalance);
    return LineChartData(
      minX: 0,
      maxX: 100,
      maxY: 5,
      minY: 0,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          tooltipPadding: EdgeInsets.all(16),
          getTooltipItems: (barSpots) {
            return ChartHelper.shared
                .getLineChartTouchData(barSpots, interval, widget.data);
          },
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
          bottomTitles: ChartHelper.shared
              .getBottomTiles(interval, widget.cateogry, deltaFactor),
          leftTitles: ChartHelper.shared.getLeftSideTiles(amountInterval, true),
          rightTitles: ChartHelper.shared.getRightSideTiles()),
      borderData: ChartHelper.shared.getChartBorder(true),
      lineBarsData: linesBarDetails(),
    );
  }
}
