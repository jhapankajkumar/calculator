import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool shouldAdjustInflation = false;
  double? result;
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;

  double? _calculateSIP() {
    if (rate == null) {
      return null;
    }

    double? interestRate = rate;
    if (shouldAdjustInflation && inflationrate != null) {
      interestRate = (rate ?? 0) - (inflationrate ?? 0);
    }
    print('Interest Rate: $interestRate');
    print('Inflation Rate: $inflationrate');
    print('Amount: $amount');
    print('Period: $period');

    double roi = (interestRate ?? 0) / 100 / 12;
    print('ROI:$roi');
    num power = pow(1 + roi, 12 * (period ?? 0));
    print('Power:  $power');
    double value = (((power - 1) * (amount ?? 0)) / roi) * (1 + roi);
    // print(value);
    return value.roundToDouble();
  }

  bool isAllInputValid() {
    bool isValid = true;
    if (rate == null) {
      isValid = false;
    }
    if (amount == null) {
      isValid = false;
    }
    if (period == null) {
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: buildContainer(context, deviceWidth),
        ));
  }

  Container buildContainer(BuildContext context, double deviceWidth) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        color: Colors.lightBlue[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _amountSection(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: (deviceWidth - 48) / 2,
                    child: _periodSection(context)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: (deviceWidth - 48) / 2, child: _rateSection(context))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: (deviceWidth - 48) / 2,
                    child: _inflationSection(context)),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: (deviceWidth - 48) / 2,
                    child: shouldAdjustInflation
                        ? _inflationRateSection(context)
                        : Container())
              ],
            ),
            ElevatedButton(
                onPressed: isAllInputValid()
                    ? () {
                        setState(() {
                          result = _calculateSIP();
                          print(result);
                        });
                      }
                    : null,
                child: Text("Calculate")),
            Text('$result'),
          ],
        ));
  }

  Widget _amountSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Monthly Investment Amount (Rs.)",
        style: TextStyle(color: Colors.deepOrangeAccent[100], fontSize: 14.0),
      ),
      TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Amount"),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (value) {
          print(value);
        },
        onChanged: (value) {
          setState(() {
            double inputtedAmount = double.parse(value);
            if (inputtedAmount.isNaN == false) {
              amount = inputtedAmount;
            } else {
              amount = null;
            }
          });
        },
        onEditingComplete: () {
          print("Completed");
        },
      ),
    ]);
  }

  Widget _periodSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Period.",
        style: TextStyle(color: Colors.deepOrangeAccent[100], fontSize: 14.0),
      ),
      TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Period"),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (value) {
          print(value);
        },
        onChanged: (value) {
          setState(() {
            double inputtedPeriod = double.parse(value);
            if (inputtedPeriod.isNaN == false) {
              period = inputtedPeriod;
            } else {
              period = null;
            }
          });
        },
        onEditingComplete: () {
          print("Completed");
        },
      ),
    ]);
  }

  Widget _rateSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Interest Rate.",
        style: TextStyle(color: Colors.deepOrangeAccent[100], fontSize: 14.0),
      ),
      TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Interest Rate"),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (value) {
          print(value);
        },
        onChanged: (value) {
          setState(() {
            double inputtedRate = double.parse(value);
            if (inputtedRate.isNaN == false) {
              rate = inputtedRate;
            } else {
              rate = null;
            }
          });
        },
        onEditingComplete: () {
          print("Completed");
        },
      ),
    ]);
  }

  Widget _inflationRateSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Inflation Rate.",
        style: TextStyle(color: Colors.deepOrangeAccent[100], fontSize: 14.0),
      ),
      TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: "Inflation Rate"),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSubmitted: (value) {
          print(value);
        },
        onChanged: (value) {
          setState(() {
            double inputtedRate = double.parse(value);
            if (inputtedRate.isNaN == false) {
              inflationrate = inputtedRate;
            } else {
              inflationrate = null;
            }
          });
        },
        onEditingComplete: () {
          print("Completed");
        },
      ),
    ]);
  }

  Widget _inflationSection(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Adjust Inflation?",
        style: TextStyle(color: Colors.deepOrangeAccent[100], fontSize: 14.0),
      ),
      Checkbox(
        value: shouldAdjustInflation,
        onChanged: (value) {
          setState(() {
            shouldAdjustInflation = !shouldAdjustInflation;
          });
        },
      )
    ]);
  }
}
