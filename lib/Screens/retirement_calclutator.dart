import 'package:calculator/Screens/retirement_detail.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/error_message_view.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/retirement_data.dart';
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
  bool invalidAge = false;
  bool invalidRetirementAge = false;
  bool invalidLifeExpectancy = false;

  double? futureInvestmentValue;
  double? futureMonthlyExpenses;

  double? retirementCorpus;
  double? sipAmount;
  double? lumpsumAmount;
  ErrorType? ageErrorType;
  ErrorType? retirementAgeErrorType;
  ErrorType? lifeExpecancyErrorType;
  RetirementResult result = RetirementResult();

  bool isInvalidInflation = false;
  bool isInvalidReturn = false;
  bool isInvalidReturnOnCorpus = false;

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

    retirementCorpus = helper.pv(
        interestRate, lifePeriod, -(futureMonthlyExpenses! * 12), 0, 1);
    // print('Corpus $retirementCorpus');
    result.corpusAmount = retirementCorpus ?? 0;
    retirementCorpus = (retirementCorpus ?? 0) - (futureInvestmentValue ?? 0);
    // print('Corpus $retirementCorpus');
    sipAmount = helper.getSIPAmount(
        retirementCorpus ?? 0,
        expectedRORetirement ?? 0,
        period.toDouble(),
        inflationrate ?? 0,
        false,
        false);
    lumpsumAmount = helper.getLumpsumValueAmount(retirementCorpus ?? 0,
        expectedRORetirement ?? 0, period.toDouble(), 1, null, false);

    // print('Your Future monthly expenses $futureMonthlyExpenses \n');
    // print('Your Future Investment Value $futureInvestmentValue \n');
    // print('Amount needed for retirement $retirementCorpus \n');
    // print('SIP needed for retirement $sipAmount \n');
    // print('Lumpsum needed for retirement $lumpsumAmount \n');
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
    if (age == null ||
        retirementAge == null ||
        lifeExpectancy == null ||
        expectedRORetirement == null ||
        currentExpenses == null) {
      isValid = false;
    }

    if (isInvalidInflation || isInvalidReturn || isInvalidReturnOnCorpus) {
      isValid = false;
    }

    if (ageErrorType != null ||
        retirementAgeErrorType != null ||
        lifeExpecancyErrorType != null) {
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
          validateROI();
        } else {
          expectedROI = null;
        }
      });
    }

    if (textField == TextFieldFocus.interestRate) {
      setState(() {
        if (inputtedValue > 0) {
          expectedRORetirement = inputtedValue;
          validateROR();
        } else {
          expectedRORetirement = null;
        }
      });
    }

    if (textField == TextFieldFocus.inflationrate) {
      setState(() {
        if (inputtedValue > 0) {
          inflationrate = inputtedValue;
          validateInflation();
        } else {
          inflationrate = null;
        }
      });
    }
  }

  _onFocusChange(TextFieldFocus? textField, bool value) {
    if (textField == TextFieldFocus.age) {
      //resigning responder
      if (value == false) {
        if (age != null) {
          validateAge();
          if (ageErrorType == null) {
            if (retirementAge != null) {
              if (age! >= retirementAge!) {
                // showAlert('Your age should be less than retirement age.');
                setState(() {
                  invalidAge = true;
                  ageErrorType = ErrorType.invalidAge;
                });
              } else {
                setState(() {
                  invalidAge = false;
                  ageErrorType = null;
                });
                if (lifeExpectancy != null) {
                  if (retirementAge! < lifeExpectancy! &&
                      retirementAgeErrorType ==
                          ErrorType.invalidRetirementAge) {
                    setState(() {
                      invalidRetirementAge = false;
                      retirementAgeErrorType = null;
                    });
                  }
                }
              }
            }
          }
        }
      } // becoming responder
      else {
        setState(() {
          currentFocus = textField;
          invalidAge = false;
          ageErrorType = null;
        });
      }
    } else if (textField == TextFieldFocus.retirementAge) {
      //resigning responder
      if (value == false) {
        if (retirementAge != null) {
          validateRetirementAge();
          if (retirementAgeErrorType == null) {
            if (age != null && lifeExpectancy != null) {
              if (retirementAge! <= age! || retirementAge! >= lifeExpectancy!) {
                setState(() {
                  invalidRetirementAge = true;
                  retirementAgeErrorType = ErrorType.invalidRetirementAge;
                });
                // showAlert('Retirement age should be more than current age.');
              } else {
                setState(() {
                  invalidRetirementAge = false;
                  retirementAgeErrorType = null;
                  if (invalidAge == true &&
                      ageErrorType == ErrorType.invalidAge) {
                    invalidAge = false;
                    ageErrorType = null;
                  }
                  if (invalidLifeExpectancy &&
                      lifeExpecancyErrorType ==
                          ErrorType.invalidLifeExpectancy) {
                    invalidLifeExpectancy = false;
                    lifeExpecancyErrorType = null;
                  }
                });
              }
            } else if (age != null) {
              if (retirementAge! <= age!) {
                setState(() {
                  invalidRetirementAge = true;
                  retirementAgeErrorType = ErrorType.invalidRetirementAge;
                });
              } else {
                setState(() {
                  invalidRetirementAge = false;
                  retirementAgeErrorType = null;
                  if (invalidAge == true &&
                      ageErrorType == ErrorType.invalidAge) {
                    invalidAge = false;
                    ageErrorType = null;
                  }
                });
              }
            } else if (lifeExpectancy != null) {
              if (retirementAge! >= lifeExpectancy!) {
                setState(() {
                  invalidRetirementAge = true;
                  retirementAgeErrorType = ErrorType.invalidRetirementAge;
                });
                // showAlert('Retirement age should be less than life expectancy.');
              } else {
                setState(() {
                  invalidRetirementAge = false;
                  retirementAgeErrorType = null;
                  if (invalidLifeExpectancy &&
                      lifeExpecancyErrorType ==
                          ErrorType.invalidLifeExpectancy) {
                    invalidLifeExpectancy = false;
                    lifeExpecancyErrorType = null;
                  }
                });
              }
            }
          }
        }
      } else {
        setState(() {
          currentFocus = textField;
          invalidRetirementAge = false;
          retirementAgeErrorType = null;
        });
      }
    } else if (textField == TextFieldFocus.lifeExpectancy) {
      if (value == false) {
        if (lifeExpectancy != null) {
          validateLifeExpectancyAge();
          if (lifeExpecancyErrorType == null) {
            if (retirementAge != null) {
              if (lifeExpectancy! <= retirementAge!) {
                setState(() {
                  invalidLifeExpectancy = true;
                  lifeExpecancyErrorType = ErrorType.invalidLifeExpectancy;
                });
              } else {
                setState(() {
                  invalidLifeExpectancy = false;
                  lifeExpecancyErrorType = null;
                });
                if (age != null) {
                  if (retirementAge! > age! &&
                      retirementAgeErrorType ==
                          ErrorType.invalidRetirementAge) {
                    setState(() {
                      invalidRetirementAge = false;
                      retirementAgeErrorType = null;
                    });
                  }
                } else if (retirementAgeErrorType ==
                    ErrorType.invalidRetirementAge) {
                  setState(() {
                    invalidRetirementAge = false;
                    retirementAgeErrorType = null;
                  });
                }
              }
            }
          }
        }
      } else {
        setState(() {
          currentFocus = textField;
          invalidLifeExpectancy = false;
          lifeExpecancyErrorType = null;
        });
      }
    } else {
      if (value == true) {
        setState(() {
          currentFocus = textField;
        });
      }
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

  void validateAge() {
    if (age != null) {
      if ((age ?? 0) < minCurrentAge) {
        setState(() {
          invalidAge = true;
          ageErrorType = ErrorType.minAge;
        });
      }
      if ((age ?? 0) > maxCurrentAge) {
        setState(() {
          invalidAge = true;
          ageErrorType = ErrorType.maxAge;
        });
      }
    }
  }

  void validateRetirementAge() {
    if (retirementAge != null) {
      if ((retirementAge ?? 0) < minRetirementAge) {
        setState(() {
          invalidRetirementAge = true;
          retirementAgeErrorType = ErrorType.minRetirementAge;
        });
      }
      if ((retirementAge ?? 0) > maxRetirementAge) {
        setState(() {
          invalidRetirementAge = true;
          retirementAgeErrorType = ErrorType.maxRetirementAge;
        });
      }
    }
  }

  void validateLifeExpectancyAge() {
    if (lifeExpectancy != null) {
      if (lifeExpectancy! < minLifeExpectancy) {
        setState(() {
          invalidLifeExpectancy = true;
          lifeExpecancyErrorType = ErrorType.minLifeExpectancy;
        });
      }
      if (lifeExpectancy! > maxLifeExpectancy) {
        setState(() {
          invalidLifeExpectancy = true;
          lifeExpecancyErrorType = ErrorType.maxLifeExpectancy;
        });
      }
    }
  }

  void validateInflation() {
    setState(() {
      if ((inflationrate ?? 0) > maxInflationRate) {
        isInvalidInflation = true;
      } else {
        isInvalidInflation = false;
      }
    });
  }

  void validateROI() {
    setState(() {
      if ((expectedROI ?? 0) > interestRateMaxValue) {
        isInvalidReturn = true;
      } else {
        isInvalidReturn = false;
      }
    });
  }

  void validateROR() {
    setState(() {
      if ((expectedRORetirement ?? 0) > interestRateMaxValue) {
        isInvalidReturnOnCorpus = true;
      } else {
        isInvalidReturnOnCorpus = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(category: widget.category, context: context),
        body: baseContainer(
            onTap: null,
            context: context,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            // color: appTheme.accentColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 0, 10),
                              child: Text(
                                "Personal information",
                                style: appTheme.textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    buildPersonalInformationContainer(context),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            // color: appTheme.accentColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 0, 10),
                              child: Text(
                                "Investment information",
                                style: appTheme.textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _ageSection(context),
          invalidAge == true ? buildErrorView(ageErrorType) : Container(),
          SizedBox(height: 20),
          _retirementAgeSection(context),
          invalidRetirementAge == true
              ? buildErrorView(retirementAgeErrorType)
              : Container(),
          SizedBox(height: 20),
          _lifeExpectancy(context),
          invalidLifeExpectancy == true
              ? buildErrorView(lifeExpecancyErrorType)
              : Container(),
          SizedBox(height: 20),
          _currentHouseHoldExpenses(context),
        ]));
  }

  Widget buildInvestmentInformationContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _currentInvestments(context),
          SizedBox(height: 20),
          _returnRateOnInvestments(context),
          isInvalidReturn
              ? buildErrorView(ErrorType.maxReturnRate)
              : Container(),
          SizedBox(height: 20),
          _returnOnRetirementCorpus(context),
          isInvalidReturnOnCorpus
              ? buildErrorView(ErrorType.maxRetirementCorpusReturn)
              : Container(),
          SizedBox(height: 20),
          _inflationRate(context),
          isInvalidInflation
              ? buildErrorView(ErrorType.maxInflationRate)
              : Container(),
          SizedBox(height: 20),
        ]));
  }

  Widget _currentInvestments(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.investmentAmount,
      textFieldType: TextFieldType.number,
      placeHolder: "10000000",
      textLimit: currentinvestmentLimit,
      containerTitle: "My current investment amount is",
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
      placeHolder: "12",
      textLimit: interestRateTextLimit,
      containerTitle: "My expected rate of return on investments (% per annum)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
      isError: isInvalidReturn,
    );
  }

  Widget _returnOnRetirementCorpus(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.interestRate,
      textFieldType: TextFieldType.decimal,
      placeHolder: "8",
      textLimit: interestRateTextLimit,
      containerTitle: "My expected return on retirement corpus (% per annum)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
      isError: isInvalidReturnOnCorpus,
    );
  }

  Widget _inflationRate(BuildContext context) {
    return buildTextFieldContainerSection(
      textField: TextFieldFocus.inflationrate,
      textFieldType: TextFieldType.decimal,
      placeHolder: "6",
      textLimit: interestRateTextLimit,
      containerTitle: "My expected inflation rate over the years (% per annum)",
      focus: currentFocus,
      onFocusChange: _onFocusChange,
      onTextChange: _onTextChange,
      onDoneButtonTapped: _onDoneButtonTapped,
      isError: isInvalidInflation,
    );
  }

  Widget _ageSection(BuildContext context) {
    return buildTextFieldContainerSection(
        textField: TextFieldFocus.age,
        textFieldType: TextFieldType.number,
        placeHolder: "25",
        textLimit: ageLimit,
        containerTitle: "My Current age is",
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
      containerTitle: "I want to retire at age",
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
        containerTitle: "I am expecting to live till age",
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
      placeHolder: "25000",
      textLimit: expensLimit,
      containerTitle: "My current monthly household expenses is",
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
