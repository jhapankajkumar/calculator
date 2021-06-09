import 'package:calculator/util/Constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final double? corpusAmount;
  final double? wealthGain;
  final double? amountInvested;

  Chart({this.amountInvested, this.corpusAmount, this.wealthGain});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: chartSectionSize,
      child: Center(
        child: PieChart(
          PieChartData(
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
              startDegreeOffset: 270,
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: showingSections()),
        ),
      ),
    );
  }

  List<PieChartSectionData>? showingSections() {
    List<PieChartSectionData>? sectionData;
    double? gainPercentage = _getGainPercentage();
    double? investmentPercentage = _getInvestmentPercentage();
    final double radius = chartRadisuSize;
    if ((wealthGain ?? 0).compareTo(0) > 0 && wealthGain?.isInfinite == false) {
      if (gainPercentage > 99.99) {
        sectionData = List.generate(1, (i) {
          return PieChartSectionData(
            color: wealthColor.withOpacity(1.0),
            value: _getGainPercentage(),
            title: '',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: bodyText2FontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff044d7c)),
            titlePositionPercentageOffset: 0.55,
          );
        });
      } else {
        sectionData = List.generate(2, (i) {
          switch (i) {
            case 0:
              return PieChartSectionData(
                color: wealthColor.withOpacity(1.0),
                value: gainPercentage,
                title: "",
                radius: radius,
                titleStyle: TextStyle(
                    fontSize: bodyText2FontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff044d7c)),
                titlePositionPercentageOffset: 0.55,
              );
            case 1:
              return PieChartSectionData(
                color: ternaryColor.withOpacity(1.0),
                value: investmentPercentage,
                title: "",
                radius: radius,
                titleStyle: TextStyle(
                    fontSize: bodyText2FontSize,
                    fontWeight: FontWeight.bold,
                    color: ternaryColor),
                titlePositionPercentageOffset: 0.55,
              );
            default:
              return PieChartSectionData();
          }
        });
      }
    } else if (corpusAmount?.isInfinite == true) {
      sectionData = List.generate(1, (i) {
        return PieChartSectionData(
          color: wealthColor.withOpacity(1.0),
          value: _getGainPercentage(),
          title: '',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: bodyText2FontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xff044d7c)),
          titlePositionPercentageOffset: 0.55,
        );
      });
    } else {
      sectionData = List.generate(1, (i) {
        return PieChartSectionData(
          color: const Color(0xfff8b250).withOpacity(1.0),
          value: _getInvestmentPercentage(),
          title: '',
          radius: radius,
          titleStyle: TextStyle(
              fontSize: bodyText2FontSize,
              fontWeight: FontWeight.bold,
              color: ternaryColor),
          titlePositionPercentageOffset: 0.55,
        );
      });
    }
    return sectionData;
  }

  double _getGainPercentage() {
    if ((wealthGain ?? 0) < 0) {
      return 0;
    }
    if (corpusAmount?.isInfinite ?? false) {
      return 100;
    }
    return (wealthGain ?? 0) / (corpusAmount ?? 0) * 100;
  }

  double _getInvestmentPercentage() {
    if ((amountInvested ?? 0) < 0) {
      return 0;
    }
    return (amountInvested ?? 0) / (corpusAmount ?? 0) * 100;
  }
}
