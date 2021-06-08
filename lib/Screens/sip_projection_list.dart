import 'dart:ffi';
import 'dart:math';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SIPProjetionList extends StatefulWidget {
  final SIPResultData data;
  SIPProjetionList(this.data);
  @override
  _SIPProjetionListState createState() => _SIPProjetionListState();
}

class _SIPProjetionListState extends State<SIPProjetionList> {
  final formatter = new NumberFormat("##,###");
  int _currentSelection = 0;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();

    fillAmount(context);
  }

  void fillAmount(BuildContext context) {
    List<SIPData> list = [];
    for (int i = 1; i <= widget.data.tenor; i++) {
      SIPData sipData = SIPData();
      sipData.tenor = i;
      double corpus = getSipAmount(i.toDouble()) ?? 0;
      double amount = widget.data.initialAmount * i * 12;
      double? interest = corpus - amount;
      sipData.totalBalance = corpus;
      sipData.amount = amount;
      sipData.interest = interest;
      list.add(sipData);
    }
    setState(() {
      widget.data.list = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Investment Detail", context: context),
        body: baseContainer(
            context: context,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialSegmentedControl(
                    children: {
                      0: Text(
                        '          Chart          ',
                        style: TextStyle(
                            color: (this._currentSelection == 0
                                ? Colors.white
                                : appTheme.accentColor)),
                      ),
                      1: Text(
                        '          Table          ',
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
                      ? buildChart(context)
                      : Expanded(child: buildT(context)),
                ],
              ),
            )));
  }

  Widget buildT(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return StickyHeader(
              header: buildTableHeader(), content: buildTableContent(context));
        },
      ),
    );
  }

  Widget buildTableContent(BuildContext context) {
    List<Widget> children = [];
    int? limit = (widget.data.list?.length ?? 0) > 100
        ? 100
        : (widget.data.list?.length ?? 0);
    for (int i = 0; i < (limit); i++) {
      var data = widget.data.list?[i];
      if (data != null) {
        children.add(buildContent(context, data, i));
      }
    }

    return Column(
      children: <Widget>[
        Card(
          child: Container(
              child: Column(
            children: children,
          )),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, SIPData data, int index) {
    double width = MediaQuery.of(context).size.width;
    double rowHeight = 80;
    List<Widget> children = [];
    for (int i = 0; i < (data.list?.length ?? 0); i++) {
      var detailData = data.list?[i];
      if (detailData != null) {
        children.add(buildDetailContent(context, detailData, i));
        children.add(Container(
          height: 1,
          color: Colors.grey,
        ));
      }
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (data.isExpanded == false) {
            data.isExpanded = true;
          } else {
            data.isExpanded = false;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: index == 0
                ? appTheme.secondaryHeaderColor
                : (index % 2 == 0 ? appTheme.primaryColor : Colors.white)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: width / 4 + 20,
                    height: rowHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image(
                        //   image: AssetImage('assets/images/expand.png'),
                        //   width: 16,
                        //   height: 16,
                        // ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Center(
                            child: Text(
                              "${(data.tenor?.toInt())} Years",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: caption2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Flexible(
                      child: Text(
                        "\$${k_m_b_generator(data.amount ?? 0)}",
                        textAlign: TextAlign.center,
                        style: caption2,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: rowHeight,
                    width: width / 4,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Center(
                        child: Text(
                          "\$${k_m_b_generator(data.interest ?? 0)}",
                          textAlign: TextAlign.center,
                          style: caption2,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: rowHeight,
                    width: width / 4,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Center(
                      child: Text(
                        '\$${k_m_b_generator(data.totalBalance ?? 0)}',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        style: caption2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // data.isExpanded == false
            //     ? Container()
            //     : Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(color: appTheme.accentColor, width: 1),
            //         ),
            //         child: Column(
            //           children: children,
            //         )),
          ],
        ),
      ),
    );
  }

  Widget buildDetailContent(BuildContext context, SIPData data, int index) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(color: appTheme.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: width / 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Month ${(data.tenor?.toInt())} ",
                  textAlign: TextAlign.center,
                  style: caption2,
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    "\$${data.amount?.toInt() ?? 0}",
                    textAlign: TextAlign.center,
                    style: caption3,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    "\$${data.amount?.toInt() ?? 0}",
                    textAlign: TextAlign.center,
                    style: caption3,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  '\$${k_m_b_generator(data.totalBalance ?? 0)}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: caption3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTableHeader() {
    return Container(
      color: appTheme.primaryColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                "Duration",
                style: appTheme.textTheme.caption,
              ),
            ),
          ),
          Center(
            child: Text("Amount", style: appTheme.textTheme.caption),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              "Interest",
              style: appTheme.textTheme.caption,
            ),
          )),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Text(
                "Balance",
                style: appTheme.textTheme.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  String k_m_b_generator(double num) {
    if (num.isInfinite == true) {
      return "INFINITE";
    }
    if (num < 999999999999999) {
      return "${formatter.format(num)}";
    } else {
      return num.roundToDouble().toString();
    }
  }

  Widget buildChart(BuildContext context) {
    getYAxisData();
    return Container(
      margin: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width - 32,
      height: MediaQuery.of(context).size.width - 32,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        gradient: LinearGradient(
          colors: [
            Color(0xff2c274c),
            Color(0xff46426c),
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
              const SizedBox(
                height: 10,
              ),
              const Text(
                'SIP Chart',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Total Amount',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              Text(
                '${formatter.format(widget.data.corpus)}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: LineChart(
                    sampleData1(),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Years',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  String k_m_b_generators(double num) {
    if (num < 1000) {
      return num.toString();
    } else if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999 && num < 999999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else if (num > 999999999999 && num < 999999999999999) {
      return "${(num / 1000000000000).toStringAsFixed(1)} T";
    } else if (num > 999999999999999 && num < 999999999999999999) {
      return "${(num / 1000000000000000).toStringAsFixed(1)} Q";
    } else {
      return num.toStringAsExponential(1);
    }
  }

  double maxY = 5;
  double maxX = 100;
  double interval = 0;
  double amountInterval = 0;
  LineChartData sampleData1() {
    double yValue = widget.data.corpus;
    double xValue = widget.data.tenor;

    if (xValue > 90) {
      interval = 20;
    } else if (xValue > 75) {
      interval = 20;
    } else if (xValue > 60) {
      interval = 15;
    } else if (xValue > 50) {
      interval = 12;
    } else if (xValue > 40) {
      interval = 10;
    } else if (xValue > 25) {
      interval = 8;
    } else if (xValue > 20) {
      interval = 5;
    } else if (xValue > 15) {
      interval = 4;
    } else if (xValue > 10) {
      interval = 3;
    } else if (xValue > 5) {
      interval = 2;
    } else {
      interval = 1;
    }
    print('Year Interval, $interval');

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            if (value == 0) {
              return "0";
            }
            switch (value.toInt()) {
              case 20:
              case 40:
              case 60:
              case 80:
              case 100:
                return ((value / 20 * interval)).toInt().toString();
            }

            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value == 0) {
              return "0    ";
            }
            return k_m_b_generators(amountInterval * value);
          },
          margin: 8,
          reservedSize: 65,
        ),
        rightTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '';
            },
            reservedSize: 10),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: maxX,
      maxY: maxY,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<FlSpot>? getSpotData() {
    double x = 0;
    List<FlSpot> list = [];
    list.add(FlSpot(0, 0));
    x = 20;
    int i = interval.toInt();
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.list?.length ?? 0); i = i + interval.toInt()) {
      var amount = getSipAmount(i.toDouble());
      print('$i SIP Amount $amount');
      String sPoint =
          ((amount ?? 0) / (widget.data.corpus) * 5).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + 20;
    }

    if (tenor % interval != 0) {
      var amount = getSipAmount(tenor.toDouble());
      print('$tenor SIP Amount $amount');
      x = x - (20 / interval);
      String sPoint =
          ((amount ?? 0) / (widget.data.corpus) * 5).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      print("SIP SPOTS $element");
    });
    return list;
  }

  List<FlSpot>? getSpotDataWithAmount() {
    double x = 0;
    List<FlSpot> list = [];
    list.add(FlSpot(0, 0));
    x = 20;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.list?.length ?? 0);
        i = i + interval.toInt()) {
      var amount = getSumAmount(i.toDouble());
      print('$i Sum Amount $amount');
      String sPoint =
          ((amount) / ((widget.data.corpus)) * 5).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + 20;
    }
    if (tenor % interval != 0) {
      var amount = getSumAmount(tenor.toDouble());
      print('$tenor Sum Amount $amount');
      x = x - (20 / interval);
      String sPoint = ((amount) / (widget.data.corpus) * 5).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    return list;
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: getSpotData(),
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: getSpotDataWithAmount(),
      isCurved: true,
      colors: [
        Colors.red,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      // lineChartBarData3,
    ];
  }

  double getSumAmount(double duration) {
    double sum = 0;
    var sipAmount = widget.data.initialAmount;
    sum = sum + (sipAmount * duration * 12);
    return sum;
  }

  double? getSipAmount(double? duration) {
    var stepupFinalAmount = 0.0;
    var sipAmount = widget.data.initialAmount;
    var totalInvestAmount = sipAmount;
    var s = (widget.data.initialSteupRate) / 100;
    var n = (duration ?? 0) * 12;
    var roi = (widget.data.initialInterestRate) / 100 / 12;
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

  List<Double> getYAxisData() {
    print("Y DATA");
    print("${widget.data.corpus}");
    double leading =
        double.parse(widget.data.corpus.toString().substring(0, 2));
    print(leading);
    if (leading > 75) {
      amountInterval = 20;
    } else if (leading > 60) {
      amountInterval = 15;
    } else if (leading > 50) {
      amountInterval = 12;
    } else if (leading > 40) {
      amountInterval = 10;
    } else if (leading > 25) {
      amountInterval = 8;
    } else if (leading > 20) {
      amountInterval = 5;
    } else if (leading > 15) {
      amountInterval = 4;
    } else if (leading > 10) {
      amountInterval = 3;
    } else if (leading > 5) {
      amountInterval = 2;
    } else {
      amountInterval = 1;
    }
    int digitToPad = 0;
    if (amountInterval < 10) {
      digitToPad = widget.data.corpus.toString().length - 3;
    } else {
      digitToPad = widget.data.corpus.toString().length - 2;
    }
    print('Amount Interval, $amountInterval');
    String amount = amountInterval.toInt().toString().padRight(digitToPad, '0');
    amountInterval = double.parse(amount);
    print('Amount Interval, $amountInterval');
    return [];
  }
}
