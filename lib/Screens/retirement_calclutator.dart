import 'package:calculator/Screens/retirement_detail.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/retirement_data.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetirementCalculator extends StatefulWidget {
  RetirementCalculator({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Screen category;

  @override
  _RetirementCalculatorState createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends State<RetirementCalculator> {
  //personal information
  int? age;
  int? retirementAge;
  int? lifeExpectancy;
  double? currentExpenses;

  //Investment informatino
  double? currentInvestments;
  double? expectedROI;
  double? expectedRORetirement;
  double? inflationrate;
  TextFieldFocus? currentFocus;
  bool? invalidAge;
  bool? invalidRetirementAge;
  bool? invalidLifeExpectancy;

  double? futureInvestmentValue;
  double? futureMonthlyExpenses;

  double? retirementCorpus;
  double? sipAmount;
  double? lumpsumAmount;

  RetirementResult result = RetirementResult();

  _calculateSIP() {
    var helper = UtilityHelper();
    int period = retirementAge! - age!;
    int lifePeriod = ((lifeExpectancy ?? 0) - (retirementAge ?? 0));

    futureMonthlyExpenses = helper
        .getFutureValueAmount(
            currentExpenses ?? 0, inflationrate ?? 0, period.toDouble(), 1)
        .roundToDouble();
    futureInvestmentValue = helper
        .getFutureValueAmount(
            currentInvestments ?? 0, expectedROI ?? 0, period.toDouble(), 1)
        .roundToDouble();
    double? interestRate = (1 + (expectedRORetirement! / 100)) /
            (1 + ((inflationrate ?? 0) / 100)) -
        1;

    print(interestRate);
    retirementCorpus = helper.pv(
        interestRate, lifePeriod, -(futureMonthlyExpenses! * 12), 0, 1);
    print('Corpus $retirementCorpus');
    result.corpusAmount = retirementCorpus ?? 0;
    retirementCorpus = (retirementCorpus ?? 0) - (futureInvestmentValue ?? 0);
    print('Corpus $retirementCorpus');
    sipAmount = helper.getSIPAmount(
        retirementCorpus ?? 0,
        expectedRORetirement ?? 0,
        period.toDouble(),
        inflationrate ?? 0,
        false,
        false);

    lumpsumAmount = helper.getLumpsumValueAmount(retirementCorpus ?? 0,
        expectedRORetirement ?? 0, period.toDouble(), 1, null, false);

    print('Your Future monthly expenses $futureMonthlyExpenses \n');
    print('Your Future Investment Value $futureInvestmentValue \n');
    print('Amount needed for retirement $retirementCorpus \n');
    print('SIP needed for retirement $sipAmount \n');
    print('Lumpsum needed for retirement $lumpsumAmount \n');
    result.period = period;
    result.currentExpenses = currentExpenses ?? 0;
    result.futureExpenses = futureMonthlyExpenses ?? 0;
    result.currentInvestmentAmount = currentInvestments ?? 0;
    result.futureInvestmentsAmount = futureInvestmentValue ?? 0;
    result.sipAmount = sipAmount ?? 0;
    result.lumpsumAmount = lumpsumAmount ?? 0;
    result.inflationRate = inflationrate ?? 0;
    result.finalRetirementAmount = retirementCorpus ?? 0;

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RetirementCalulationResult(
        category: Screen.detail,
        result: result,
      );
    }));
  }

  bool isAllInputValid() {
    bool isValid = true;
    if (age == null) {
      isValid = false;
    }
    if (retirementAge == null) {
      isValid = false;
    }

    if (lifeExpectancy == null) {
      isValid = false;
    }

    if ((retirementAge ?? 0) <= (age ?? 0)) {
      isValid = false;
    }

    if ((lifeExpectancy ?? 0) <= (age ?? 0)) {
      isValid = false;
    }

    if (expectedRORetirement == null) {
      isValid = false;
    }

    return isValid;
  }

  _onTextChange(TextFieldFocus? textField, String value) {
    bool emptyString = value.length == 0;
    double inputtedValue = 0;
    int inputtedIntValue = 0;
    if (emptyString == false) {
      inputtedValue = double.parse(value);
      inputtedIntValue = int.parse(value);
    }
    if (textField == TextFieldFocus.age) {
      setState(() {
        print(inputtedIntValue);
        if (inputtedIntValue > 0) {
          age = inputtedIntValue;
        } else {
          age = null;
        }
      });
    }

    if (textField == TextFieldFocus.retirementAge) {
      setState(() {
        if (inputtedIntValue > 0) {
          retirementAge = inputtedIntValue;
        } else {
          retirementAge = null;
        }
      });
    }

    if (textField == TextFieldFocus.lifeExpectancy) {
      setState(() {
        if (inputtedIntValue > 0) {
          lifeExpectancy = inputtedIntValue;
        } else {
          lifeExpectancy = null;
        }
      });
    }

    if (textField == TextFieldFocus.expenses) {
      setState(() {
        if (inputtedValue > 0) {
          currentExpenses = inputtedValue;
        } else {
          currentExpenses = null;
        }
      });
    }

    if (textField == TextFieldFocus.investmentAmount) {
      setState(() {
        if (inputtedValue > 0) {
          currentInvestments = inputtedValue;
        } else {
          currentInvestments = null;
        }
      });
    }

    if (textField == TextFieldFocus.roi) {
      setState(() {
        if (inputtedValue > 0) {
          expectedROI = inputtedValue;
        } else {
          expectedROI = null;
        }
      });
    }

    if (textField == TextFieldFocus.interestRate) {
      setState(() {
        if (inputtedValue > 0) {
          expectedRORetirement = inputtedValue;
        } else {
          expectedRORetirement = null;
        }
      });
    }

    if (textField == TextFieldFocus.inflationrate) {
      setState(() {
        if (inputtedValue > 0) {
          inflationrate = inputtedValue;
        } else {
          inflationrate = null;
        }
      });
    }
  }

  _onFocusChange(TextFieldFocus? textField, bool value) {
    // if (textField == TextFieldFocus.age) {
    //   //resigning responder
    //   if (value == false) {
    //     if (retirementAge != null && age != null) {
    //       if (retirementAge! <= age!) {
    //         // showAlert('Your age should be less than retirement age.');
    //         setState(() {
    //           invalidAge = true;
    //         });
    //       } else {
    //         setState(() {
    //           invalidAge = false;
    //           invalidRetirementAge = false;
    //         });
    //       }
    //     } else if (lifeExpectancy != null && age != null) {
    //       if (lifeExpectancy! <= age!) {
    //         setState(() {
    //           invalidAge = true;
    //         });
    //         // showAlert('Your age should be less than lifeExpectancy.');
    //       } else {
    //         setState(() {
    //           invalidAge = false;
    //           invalidLifeExpectancy = false;
    //         });
    //       }
    //     }
    //   }
    // } else if (textField == TextFieldFocus.retirementAge) {
    //   //resigning responder
    //   if (value == false) {
    //     if (retirementAge != null && age != null) {
    //       if (retirementAge! <= age!) {
    //         setState(() {
    //           invalidRetirementAge = true;
    //         });
    //         // showAlert('Retirement age should be more than current age.');
    //       } else {
    //         setState(() {
    //           invalidRetirementAge = false;
    //           invalidAge = false;
    //         });
    //       }
    //     } else if (lifeExpectancy != null && retirementAge != null) {
    //       if (retirementAge! >= lifeExpectancy!) {
    //         setState(() {
    //           invalidRetirementAge = true;
    //         });
    //         // showAlert('Retirement age should be less than life expectancy.');
    //       } else {
    //         setState(() {
    //           invalidRetirementAge = false;
    //           invalidLifeExpectancy = false;
    //         });
    //       }
    //     }
    //   }
    // } else if (textField == TextFieldFocus.lifeExpectancy) {
    //   if (value == false) {
    //     if (retirementAge != null && lifeExpectancy != null && age != null) {
    //       if (retirementAge! >= lifeExpectancy! && age! >= lifeExpectancy!) {
    //         setState(() {
    //           invalidLifeExpectancy = true;
    //         });
    //         // showAlert('Life expectancy should be more than retirement age.');
    //       } else {
    //         setState(() {
    //           invalidLifeExpectancy = false;
    //           invalidRetirementAge = false;
    //         });
    //       }
    //     } else if (lifeExpectancy != null && age != null) {
    //       print("hmmm $age   $lifeExpectancy");
    //       if (age! >= lifeExpectancy!) {
    //         setState(() {
    //           invalidLifeExpectancy = true;
    //         });
    //         // showAlert('Life expectancy should be more than retirement age.');
    //       } else {
    //         setState(() {
    //           invalidAge = false;
    //           invalidLifeExpectancy = false;
    //         });
    //       }
    //     }
    //   }
    // }
    if (retirementAge != null && lifeExpectancy != null && age != null) {
      if (age! < retirementAge! && age! < lifeExpectancy!) {
        setState(() {
          invalidAge = false;
        });
      }
      if (retirementAge! < lifeExpectancy!) {
        setState(() {
          invalidRetirementAge = false;
          invalidLifeExpectancy = false;
        });
      }
      if (retirementAge! >= lifeExpectancy! && age! >= lifeExpectancy!) {
        setState(() {
          invalidLifeExpectancy = true;
        });
        // showAlert('Life expectancy should be more than retirement age.');
      } else {
        setState(() {
          invalidLifeExpectancy = false;
          invalidRetirementAge = false;
        });
      }
    } else if (retirementAge != null && lifeExpectancy != null) {
    } else if (lifeExpectancy != null && age != null) {
    } else if (retirementAge != null && age != null) {
    } else {
      setState(() {
        invalidAge = false;
        invalidLifeExpectancy = false;
        invalidRetirementAge = false;
      });
    }
    if (value == true) {
      setState(() {
        currentFocus = textField;
      });
    }
  }

  removeFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (this.currentFocus != null) {
      setState(() {
        this.currentFocus = null;
      });
    }
  }

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
    });
  }

  void _calculateButtonTapped() {
    {
      _calculateSIP();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(category: widget.category, context: context),
        body: baseContainer(
            onTap: removeFocus,
            context: context,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                      child: Text(
                        "Personal information",
                        style: appTheme.textTheme.subtitle1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildPersonalInformationContainer(context),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                      child: Text(
                        "Investment information",
                        style: appTheme.textTheme.subtitle1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildInvestmentInformationContainer(context),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(children: [
                        Expanded(
                            child: genericButton(
                                title: StringConstants.calculate,
                                onPress: isAllInputValid()
                                    ? _calculateButtonTapped
                                    : null)),
                      ]),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ))));
  }

  Widget buildPersonalInformationContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            // color: Colors.white,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey,
            //     spreadRadius: 2,
            //     blurRadius: 2,
            //     offset: Offset(1, 1), // changes position of shadow
            //   )
            // ],
            ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // _ageSection(context),
          // SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: (deviceWidth - 64) / 2, child: _ageSection(context)),
              Container(
                  width: (deviceWidth - 64) / 2,
                  child: _retirementAgeSection(context))
            ],
          ),
          SizedBox(height: 10),
          _lifeExpectancy(context),
          SizedBox(height: 10),
          _currentHouseHoldExpenses(context),
        ]));
  }

  Widget buildInvestmentInformationContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(8)),
            // color: Colors.white,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey,
            //     spreadRadius: 2,
            //     blurRadius: 2,
            //     offset: Offset(1, 1), // changes position of shadow
            //   )
            // ],
            ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _currentInvestments(context),
          SizedBox(height: 20),
          _returnRateOnInvestments(context),
          SizedBox(height: 20),
          _returnOnRetirementCorpus(context),
          SizedBox(height: 20),
          _inflationRate(context),
          SizedBox(height: 20),
        ]));
  }

  Widget _currentInvestments(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.investmentAmount,
      textFieldType: TextFieldType.number,
      placeHolder: "10000000",
      textLimit: amountTextLimit,
      containerTitle: "Your current investments",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
    );
  }

  Widget _returnRateOnInvestments(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.roi,
      textFieldType: TextFieldType.decimal,
      placeHolder: "10",
      textLimit: interestRateTextLimit,
      containerTitle: "Expected return on investments(%)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
    );
  }

  Widget _returnOnRetirementCorpus(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.interestRate,
      textFieldType: TextFieldType.decimal,
      placeHolder: "10",
      textLimit: interestRateTextLimit,
      containerTitle: "Expected return on retirement corpus (%)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
    );
  }

  Widget _inflationRate(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.inflationrate,
      textFieldType: TextFieldType.decimal,
      placeHolder: "10",
      textLimit: interestRateTextLimit,
      containerTitle: "Expected inflation rate (%)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
    );
  }

  Widget _ageSection(BuildContext context) {
    return buildTextFieldContainerSection(
        textField: TextFieldFocus.age,
        textFieldType: TextFieldType.number,
        placeHolder: "25",
        textLimit: ageLimit,
        containerTitle: "Your current age",
        focus: currentFocus,
        onFocusChange: _onFocusChange,
        onTextChange: _onTextChange,
        onDoneButtonTapped: _onDoneButtonTapped,
        isError: invalidAge);
  }

  Widget _retirementAgeSection(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.retirementAge,
      textFieldType: TextFieldType.number,
      placeHolder: "55",
      textLimit: ageLimit,
      containerTitle: "Retirement age",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
      isError: invalidRetirementAge,
    );
  }

  Widget _lifeExpectancy(BuildContext context) {
    return buildTextFieldContainerSection(
        textField: TextFieldFocus.lifeExpectancy,
        textFieldType: TextFieldType.number,
        placeHolder: "85",
        textLimit: ageLimit,
        containerTitle: "Life expectancy",
        focus: currentFocus,
        onFocusChange: _onFocusChange,
        onTextChange: _onTextChange,
        onDoneButtonTapped: _onDoneButtonTapped,
        isError: invalidLifeExpectancy);
  }

  Widget _currentHouseHoldExpenses(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.expenses,
      textFieldType: TextFieldType.number,
      placeHolder: "85",
      textLimit: expensLimit,
      containerTitle: "Current household expenses",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
    );
  }

  Future<void> showAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('GrowFund'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
