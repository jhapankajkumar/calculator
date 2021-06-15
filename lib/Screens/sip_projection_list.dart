import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/indicator.dart';
import 'package:calculator/util/Components/pdf_table.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SIPProjetionList extends StatefulWidget {
  final SIPResultData data;
  final Screen category;
  SIPProjetionList({required this.category, required this.data});
  @override
  _SIPProjetionListState createState() => _SIPProjetionListState();
}

class _SIPProjetionListState extends State<SIPProjetionList> {
  int _currentSelection = 0;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? chartImage;
  @override
  void initState() {
    super.initState();
    fillAmount(context, widget.category);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      deletePreviousData();
    });
  }

  void fillAmount(BuildContext context, Screen category) {
    switch (category) {
      default:
        break;
    }
    List<SIPData> list = [];
    double sipAmount = widget.data.initialAmount;
    double steupAmount = 0;
    double counter = 1;
    for (int i = 1; i <= widget.data.tenor; i++) {
      SIPData sipData = SIPData();
      sipData.tenor = i;
      double amount = 0;
      double corpus = getSipAmount(i.toDouble()) ?? 0;
      amount = (sipAmount * i) + (steupAmount * counter);
      counter = counter + 1;
      if (i % 12 == 0) {
        counter = 1;
        steupAmount = sipAmount * widget.data.initialSteupRate / 100;
      }

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

  Future<void> deletePreviousData() async {
    var directory = await getApplicationDocumentsDirectory();
    var pngFile = File('${directory.path}/chart.png');
    var doesFileExist = await pngFile.exists();

    if (doesFileExist) {
      pngFile.delete();
    }

    var pdfFile = File('${directory.path}/detail.pdf');
    doesFileExist = await pdfFile.exists();
    if (doesFileExist) {
      pdfFile.delete();
    }
  }

  Future<void> takeScreenShot() async {
    var directory = await getApplicationDocumentsDirectory();
    screenshotController.capture().then((Uint8List? image) async {
      //print("Capture Done");
      setState(() async {
        if (image != null) {
          chartImage = image;
          var file = File('${directory.path}/chart');
          file.writeAsBytes(chartImage!);
        } else if (chartImage != null) {
          var file = File('${directory.path}/chart');
          file.writeAsBytes(chartImage!);
        }
        createPDF(context, widget.data);
      });
    }).catchError((onError) {
      if (chartImage != null) {
        var file = File('${directory.path}/chart');
        file.writeAsBytes(chartImage!);
      }
      createPDF(context, widget.data);
    });
  }

  void onTapShareButton() {
    takeScreenShot().then((value) async {
      final box = context.findRenderObject() as RenderBox?;
      var directory = await getApplicationDocumentsDirectory();
      var imagePath = '${directory.path}/detail.pdf';
      if (imagePath.isNotEmpty) {
        await Share.shareFiles([imagePath],
            text: "Please find attached detail",
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
                      ? Expanded(child: buildT(context))
                      : Expanded(child: buildChart(context)),
                  SizedBox(
                    height: 20,
                  ),
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
    int? limit = (widget.data.list?.length ?? 0) > 600
        ? 600
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
    bool isYear = false;
    String durationText = "";

    if ((index + 1) % 12 == 0) {
      isYear = true;
      durationText = '${(data.tenor ?? 0) ~/ 12} Year';
    } else {
      durationText = '${(data.tenor ?? 0)} Month';
      isYear = false;
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
            color: isYear == true
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Center(
                        child: Text(
                          "$durationText",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
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
                    child: Center(
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
          ],
        ),
      ),
    );
  }

  Container buildTableHeader() {
    return Container(
      color: appTheme.accentColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                "Duration",
                style: captionHeader,
              ),
            ),
          ),
          Center(
            child: Text("Amount", style: captionHeader),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              "Interest",
              style: captionHeader,
            ),
          )),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Text(
                "Balance",
                style: captionHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChart(BuildContext context) {
    if (widget.data.corpus.toString().length > 16) {
      return Text('Data is too larget to fit in chart');
    }
    return Screenshot(
      controller: screenshotController,
      child: Container(
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
                  'Total Expected Amount',
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
                  '\$ ${formatter.format(widget.data.corpus)}',
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
                          text: "Total Amount",
                          isSquare: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Indicator(
                          color: Colors.red,
                          size: indicatorSize,
                          text: "Invested amount",
                          isSquare: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Indicator(
                          color: Colors.yellow,
                          size: indicatorSize,
                          text: "Wealth gain",
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
    double xValue = widget.data.tenor;
    if (xValue > 90 * 12) {
      interval = 20 * 12;
    } else if (xValue > 75 * 12) {
      interval = 20 * 12;
    } else if (xValue > 60 * 12) {
      interval = 15 * 12;
    } else if (xValue > 50 * 12) {
      interval = 12 * 12;
    } else if (xValue > 40 * 12) {
      interval = 10 * 12;
    } else if (xValue > 25 * 12) {
      interval = 8 * 12;
    } else if (xValue > 20 * 12) {
      interval = 5 * 12;
    } else if (xValue > 15 * 12) {
      interval = 4 * 12;
    } else if (xValue > 10 * 12) {
      interval = 3 * 12;
    } else if (xValue > 5 * 12) {
      interval = 2 * 12;
    } else {
      interval = 1 * 12;
    }
    //print('Year Interval, $interval');
    getYAxisData();
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          tooltipPadding: EdgeInsets.all(16),
          getTooltipItems: (barSpots) {
            var bar = barSpots.first;
            double corpusAmount = 0;
            double investedAmount = 0;
            double wealthGain = 0;
            //print('Index: ${bar.spotIndex}');
            int index = bar.spotIndex * interval.toInt();
            var list = widget.data.list;
            //print('Index: $index');
            if (widget.data.tenor < index) {
              corpusAmount =
                  list?[widget.data.tenor.toInt() - 1].totalBalance ?? 0;
              investedAmount = list?[widget.data.tenor.toInt() - 1].amount ?? 0;
              wealthGain = list?[widget.data.tenor.toInt() - 1].interest ?? 0;
            } else if (index > 1) {
              corpusAmount = list?[index - 1].totalBalance ??
                  0; //getSipAmount(index.toDouble()) ?? 0;
              investedAmount = list?[index - 1].amount ??
                  0; //getSumAmount(index.toDouble());
              wealthGain = list?[index - 1].interest ??
                  0; //corpusAmount - investedAmount;
            }

            LineTooltipItem item1 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(corpusAmount) : 0}",
                TextStyle(
                    color: Color(0xff4af699),
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            LineTooltipItem item2 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(investedAmount) : 0}",
                TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            LineTooltipItem item3 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(wealthGain) : 0}",
                TextStyle(
                    color: Colors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            return [item1, item2, item3];
          },
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
                return (((value / 20) / 12 * interval)).toInt().toString();
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
          reservedSize: 55,
        ),
        rightTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '';
            },
            reservedSize: 5),
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
      lineBarsData: linesBarDetails(),
    );
  }

  List<FlSpot>? getCorpusSpots() {
    List<FlSpot> list = [];
    double x = 0;
    list.add(FlSpot(0, 0));
    x = 20;
    int i = interval.toInt();
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.tenor); i = i + interval.toInt()) {
      var amount = datalist?[i - 1].totalBalance ?? 0;
      //print('$i SIP Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }

    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].totalBalance ?? 0;
      //print('$tenor SIP Amount $amount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      //print(element);
    });
    return list;
  }

  List<FlSpot>? getInvestmentSpots() {
    double x = 0;
    List<FlSpot> list = [];
    list.add(FlSpot(0, 0));
    x = 20;
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      var amount = datalist?[i - 1].amount ?? 0;
      //print('$i Sum Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }
    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].amount ?? 0;
      //print('$tenor Sum Amount $amount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    return list;
  }

  List<FlSpot>? getInterestAmountSpots() {
    double x = 0;
    List<FlSpot> list = [];
    list.add(FlSpot(0, 0));
    x = 20;
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      var wealthAmount = datalist?[i - 1].interest ?? 0;
      //print('$i Wealth Amount $wealthAmount');
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }
    if (tenor % interval != 0) {
      var wealthAmount = datalist?[tenor - 1].interest ?? 0;
      //print('$tenor Wealth Amount $wealthAmount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    return list;
  }

  LineChartBarData getSipBarData() {
    return LineChartBarData(
      spots: getCorpusSpots(),
      isCurved: true,
      colors: [
        Colors.green,
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
  }

  LineChartBarData getInvestmentBarData() {
    return LineChartBarData(
      spots: getInvestmentSpots(),
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
  }

  LineChartBarData getWealthGainBarData() {
    return LineChartBarData(
      spots: getInterestAmountSpots(),
      isCurved: true,
      colors: [
        Colors.yellow,
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
  }

  List<LineChartBarData> linesBarDetails() {
    return [
      getSipBarData(),
      getInvestmentBarData(),
      getWealthGainBarData(),
    ];
  }

  // double getSumAmount(double duration) {
  //   double sum = 0;
  //   var sipAmount = widget.data.initialAmount;
  //   sum = sum + (sipAmount * duration);
  //   return sum;
  // }

  double? getSipAmount(double? duration) {
    var stepupFinalAmount = 0.0;
    var sipAmount = widget.data.initialAmount;
    var totalInvestAmount = sipAmount;
    var s = (widget.data.initialSteupRate) / 100;
    var n = (duration ?? 0);
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
    double leading =
        double.parse(widget.data.corpus.toString().substring(0, 2));
    leading = leading + 1;
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
    String amount = amountInterval.toInt().toString().padRight(digitToPad, '0');
    amountInterval = double.parse(amount);
    //print('Amount Interval, $amountInterval');
    return [];
  }
}
