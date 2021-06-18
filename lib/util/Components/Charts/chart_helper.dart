import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum SpotsType { amount, interest, withdrawal, balance }

class ChartHelper {
  static final ChartHelper shared = ChartHelper._internal();
  final Color withdrawalColor = const Color(0xff53fdd7);
  final Color startBalanceColor = const Color(0xffff5182);
  final Color interestEarnedColor = Colors.yellow;
  final Color finalBalanceColor = Colors.green;
  final double barWidth = 5;
  final double space = 10;
  factory ChartHelper() {
    return shared;
  }

  ChartHelper._internal();

  double getAmountInterval(double value) {
    double leading = double.parse(value.toString().substring(0, 2));
    double amountInterval = 0;
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
      digitToPad = value.toString().length - 3;
    } else {
      digitToPad = value.toString().length - 2;
    }
    String amount = amountInterval.toInt().toString().padRight(digitToPad, '0');
    amountInterval = double.parse(amount);
    return amountInterval;
  }

  int getTimeInterval(int tenor, int delta, Screen category) {
    int interval = 0;
    int xValue = tenor;
    if (category != Screen.stepup) {
      if (xValue > 90 * delta) {
        interval = 10 * delta;
      } else if (xValue > 75 * delta) {
        interval = 10 * delta;
      } else if (xValue > 60 * delta) {
        interval = 8 * delta;
      } else if (xValue > 50 * delta) {
        interval = 6 * delta;
      } else if (xValue > 40 * delta) {
        interval = 5 * delta;
      } else if (xValue > 30 * delta) {
        interval = 4 * delta;
      } else if (xValue > 20 * delta) {
        interval = 3 * delta;
      } else if (xValue > 10 * delta) {
        interval = 2 * delta;
      } else {
        interval = 1 * delta;
      }
    } else {
      if (xValue > 90 * delta) {
        interval = 20 * delta;
      } else if (xValue > 75 * delta) {
        interval = 20 * delta;
      } else if (xValue > 60 * delta) {
        interval = 15 * delta;
      } else if (xValue > 50 * delta) {
        interval = 12 * delta;
      } else if (xValue > 40 * delta) {
        interval = 10 * delta;
      } else if (xValue > 25 * delta) {
        interval = 8 * delta;
      } else if (xValue > 20 * delta) {
        interval = 5 * delta;
      } else if (xValue > 15 * delta) {
        interval = 4 * delta;
      } else if (xValue > 10 * delta) {
        interval = 3 * delta;
      } else if (xValue > 5 * delta) {
        interval = 2 * delta;
      } else {
        interval = 1 * delta;
      }
    }

    return interval;
  }

  FlBorderData getChartBorder(bool showLeft) {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Color(0xff4e4965),
          width: 2,
        ),
        left: BorderSide(
          color: showLeft ? Color(0xff4e4965) : Colors.transparent,
          width: 2,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    );
  }

  SideTitles getRightSideTiles() {
    return SideTitles(
        showTitles: true,
        getTitles: (value) {
          return '';
        },
        reservedSize: 5);
  }

  SideTitles getLeftSideTiles(double amountInterval, bool shouldShowZero) {
    return SideTitles(
      showTitles: true,
      rotateAngle: 25,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xff75729e),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      getTitles: (value) {
        if (shouldShowZero) {
          if (value == 0) {
            return "0    ";
          }
        }
        return k_m_b_generators(amountInterval * value);
      },
      margin: 8,
      reservedSize: 40,
    );
  }

  SideTitles getBottomTiles(int interval, Screen category, int delta) {
    return SideTitles(
      showTitles: true,
      reservedSize: 22,
      getTextStyles: (value) => TextStyle(
        color: Color(0xff72719b),
        fontWeight: FontWeight.bold,
        fontSize: category != Screen.stepup ? 12 : 16,
      ),
      margin: 10,
      rotateAngle: 0,
      getTitles: (value) {
        if (category == Screen.swp) {
          return (((value + 1) / 12 * interval)).toInt().toString();
        }
        if (category == Screen.emi) {
          return (((value + 1) / 12 * interval)).toInt().toString();
        } else {
          if (value == 0) {
            return "0";
          }
          if (value % space == 0) {
            return (((value / space) / delta * interval)).toInt().toString();
          }
          return '';
        }
      },
    );
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, double y3, double y4) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [startBalanceColor],
        width: barWidth,
      ),
      BarChartRodData(
        y: y2,
        colors: [finalBalanceColor],
        width: barWidth,
      ),
      BarChartRodData(
        y: y3,
        colors: [withdrawalColor],
        width: barWidth,
      ),
      BarChartRodData(
        y: y4,
        colors: [interestEarnedColor],
        width: barWidth,
      ),
    ]);
  }

  BarTooltipItem? getBarChartGroupTouchData(
      BarChartGroupData _a, InvestmentResult data, int interval) {
    double finalBalanceAmount = 0;
    double investedAmount = 0;
    double wealthGain = 0;
    double withdrawalAmount = 0;
    //print('Index: ${bar.spotIndex}');
    int index = (_a.x + 1) * interval.toInt();
    var list = data.list;

    if (data.tenor < index) {
      finalBalanceAmount = list?[data.tenor.toInt() - 1].balance ?? 0;
      investedAmount = list?[data.tenor.toInt() - 1].amount ?? 0;
      wealthGain = list?[data.tenor.toInt() - 1].cumulatveProfit ?? 0;
      withdrawalAmount = list?[data.tenor.toInt() - 1].cumulatveWithdrawal ?? 0;
    } else {
      finalBalanceAmount = list?[index - 1].balance ?? 0;
      investedAmount = list?[index - 1].amount ?? 0;
      wealthGain = list?[index - 1].cumulatveProfit ?? 0;
      withdrawalAmount = list?[index - 1].cumulatveWithdrawal ?? 0;
    }

    BarTooltipItem item1 = BarTooltipItem(
        "",
        TextStyle(
            color: Color(0xff4af699),
            fontSize: 14,
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
              text: '\$ ${k_m_b_generator(investedAmount)}\n',
              style: TextStyle(
                  color: startBalanceColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(
            text: '\$ ${k_m_b_generator(finalBalanceAmount)}\n',
            style: TextStyle(
                color: finalBalanceColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: '\$ ${k_m_b_generator(withdrawalAmount)}\n',
              style: TextStyle(
                  color: withdrawalColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(
              text: '\$ ${k_m_b_generator(wealthGain)}',
              style: TextStyle(
                  color: interestEarnedColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ]);
    return item1;
  }

  List<LineTooltipItem?> getLineChartTouchData(
      List<LineBarSpot> barSpots, int interval, InvestmentResult data) {
    var bar = barSpots.first;
    double finalBalanceAmount = 0;
    double investedAmount = 0;
    double wealthGain = 0;
    //print('Index: ${bar.spotIndex}');
    int index = bar.spotIndex * interval.toInt();
    var list = data.list;
    //print('Index: $index');

    if (data.tenor < index) {
      finalBalanceAmount = list?[data.tenor.toInt() - 1].balance ?? 0;
      investedAmount = list?[data.tenor.toInt() - 1].amount ?? 0;
      wealthGain = list?[data.tenor.toInt() - 1].profit ?? 0;
    } else if (index > 1) {
      finalBalanceAmount = list?[index - 1].balance ?? 0;
      investedAmount = list?[index - 1].amount ?? 0;
      wealthGain = list?[index - 1].profit ?? 0;
    }

    LineTooltipItem item1 = LineTooltipItem(
        "\$ ${bar.spotIndex > 0 ? k_m_b_generator(finalBalanceAmount) : 0}",
        TextStyle(
            color: Color(0xff4af699),
            fontSize: 14,
            fontWeight: FontWeight.bold));
    LineTooltipItem item2 = LineTooltipItem(
        "\$ ${bar.spotIndex > 0 ? k_m_b_generator(investedAmount) : 0}",
        TextStyle(
            color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold));
    LineTooltipItem item3 = LineTooltipItem(
        "\$ ${bar.spotIndex > 0 ? k_m_b_generator(wealthGain) : 0}",
        TextStyle(
            color: Colors.yellow, fontSize: 14, fontWeight: FontWeight.bold));
    return [item1, item2, item3];
  }

  List<FlSpot>? getSpotsFor(SpotsType type, int interval, double amountInterval,
      InvestmentResult data) {
    List<FlSpot> list = [];
    double x = 0;
    list.add(FlSpot(0, 0));
    x = space;
    int i = interval.toInt();
    var datalist = data.list;
    int tenor = data.tenor.toInt();
    for (; i <= (data.tenor); i = i + interval) {
      double amount = 0;
      switch (type) {
        case SpotsType.amount:
          amount = datalist?[i - 1].amount ?? 0;
          break;
        case SpotsType.interest:
          amount = datalist?[i - 1].profit ?? 0;
          break;
        case SpotsType.withdrawal:
          break;
        case SpotsType.balance:
          amount = datalist?[i - 1].balance ?? 0;
          break;
      }

      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (space);
    }

    if (tenor % interval != 0) {
      double amount = 0;
      switch (type) {
        case SpotsType.amount:
          amount = datalist?[tenor - 1].amount ?? 0;
          break;
        case SpotsType.interest:
          amount = datalist?[tenor - 1].profit ?? 0;
          break;
        case SpotsType.withdrawal:
          break;
        case SpotsType.balance:
          amount = datalist?[tenor - 1].balance ?? 0;
          break;
      }
      //print('$tenor SIP Amount $amount');
      x = x - (space) + (((space) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  LineChartBarData getLineSpotsData(SpotsType type, int interval,
      double amountInterval, InvestmentResult data, Color color) {
    return LineChartBarData(
      spots: getSpotsFor(type, interval, amountInterval, data),
      isCurved: true,
      colors: [
        color,
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

  List<double>? getPointSpots(SpotsType type, int interval,
      double amountInterval, InvestmentResult data) {
    List<double> list = [];
    int i = interval.toInt();
    var datalist = data.list;
    int tenor = data.tenor.toInt();
    for (; i <= (data.tenor); i = i + interval.toInt()) {
      double amount = 0;
      switch (type) {
        case SpotsType.amount:
          amount = datalist?[i - 1].amount ?? 0;
          break;
        case SpotsType.interest:
          amount = datalist?[i - 1].cumulatveProfit ?? 0;
          break;
        case SpotsType.withdrawal:
          amount = datalist?[i - 1].cumulatveWithdrawal ?? 0;
          break;
        case SpotsType.balance:
          amount = datalist?[i - 1].balance ?? 0;
          break;
      }
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }

    if (tenor % interval != 0) {
      double amount = 0;
      switch (type) {
        case SpotsType.amount:
          amount = datalist?[i - 1].amount ?? 0;
          break;
        case SpotsType.interest:
          amount = datalist?[tenor - 1].cumulatveProfit ?? 0;
          break;
        case SpotsType.withdrawal:
          amount = datalist?[tenor - 1].cumulatveWithdrawal ?? 0;
          break;
        case SpotsType.balance:
          amount = datalist?[tenor - 1].balance ?? 0;
          break;
      }
      //print('Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }
}
