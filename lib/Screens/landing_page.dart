import 'package:calculator/Screens/sip_calculator.dart';
import 'package:calculator/Screens/sip_detail.dart';
import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/indicator.dart';
import 'package:calculator/util/piechart.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LandingPage extends StatefulWidget {
  final String title;
  LandingPage({required this.title});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final titles = [
    'SIP Calculator',
    'Step Up SIP Calculator',
    'Future Value Calculator',
    'EMI Calculator',
    'Retirement Calculator',
  ];

  final icons = [
    Icons.email,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.directions_transit,
    Icons.directions_walk
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: titles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SIPCalculator(title: "SIP Calculator");
                        }));
                      }
                      break;
                    default:
                      break;
                  }
                },
                child: Card(
                  child: ListTile(
                    title: Text(titles[index]),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              );
            }));
  }
}
