// import 'dart:math';

// import 'package:calculator/util/Components/appbar.dart';
// import 'package:calculator/util/Components/text_field_container.dart';
// import 'package:calculator/util/Constants/constants.dart';
// import 'package:calculator/util/sip_data.dart';
// import 'package:calculator/util/utility.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RetirementCalculator extends StatefulWidget {
//   RetirementCalculator({Key? key, required this.title, required this.isSteupUp})
//       : super(key: key);
//   final String title;
//   final bool isSteupUp;

//   @override
//   _RetirementCalculatorState createState() => _RetirementCalculatorState();
// }

// class _RetirementCalculatorState extends State<RetirementCalculator> {
//   double? corpusAmount;
//   double? amount;
//   double? rate;
//   double? inflationrate;
//   double? period;

//   double? wealthGain;
//   double? investedAmount;
//   TextFieldFocus? currentFocus;
//   double? stepUpPercentage;

//   SIPData detail = SIPData();

//   _calculateSIP() {
//     var helper = UtilityHelper();
//     detail.amount = amount;
//     if (widget.isSteupUp && stepUpPercentage != null) {
//       var stepupFinalAmount = 0.0;
//       var stepupInvestAmount = 0.0;
//       var stepupInterestAmount = 0.0;
//       var sipAmount = amount;
//       var totalInvestAmount = sipAmount;
//       var s = (stepUpPercentage ?? 0) / 100;
//       var n = (period ?? 0) * 12;
//       var roi = (rate ?? 0) / 100 / 12;
//       var value3 = 1 + roi;
//       var value4 = pow(value3, n);
//       var finalValue = (sipAmount ?? 0) * value4;
//       n = n - 1;
//       while (n > 0) {
//         if (n % 12 > 0) {
//           sipAmount = sipAmount;
//           totalInvestAmount = (totalInvestAmount ?? 0) + (sipAmount ?? 0);
//           var value4 = pow(value3, n);
//           finalValue = finalValue + (sipAmount ?? 0) * value4;
//           n = n - 1;
//         } else {
//           sipAmount = (sipAmount ?? 0) + ((sipAmount ?? 0) * s);
//           totalInvestAmount = (totalInvestAmount ?? 0) + sipAmount;
//           var value4 = pow(value3, n);
//           finalValue = finalValue + sipAmount * value4;
//           n = n - 1;
//         }
//       }
//       stepupFinalAmount = finalValue.roundToDouble();
//       stepupInvestAmount = (totalInvestAmount ?? 0).roundToDouble();
//       stepupInterestAmount = stepupFinalAmount - stepupInvestAmount;
//       stepupInterestAmount = stepupInterestAmount.roundToDouble();

//       setState(() {
//         investedAmount = stepupInvestAmount;
//         corpusAmount = stepupFinalAmount;
//         wealthGain = stepupInterestAmount;
//         currentFocus = null;
//       });
//     } else {}
//   }

//   final formatter = new NumberFormat("#,###");
//   bool isAllInputValid() {
//     bool isValid = true;
//     if (rate == null) {
//       isValid = false;
//     }
//     if (amount == null) {
//       isValid = false;
//     }
//     if (period == null) {
//       isValid = false;
//     }
//     return isValid;
//   }

//   _onTextChange(TextFieldFocus? textField, String value) {
//     bool emptyString = value.length == 0;
//     double inputtedValue = 0;
//     if (emptyString == false) {
//       inputtedValue = double.parse(value);
//     }
//     if (textField == TextFieldFocus.amount) {
//       setState(() {
//         if (inputtedValue > 0) {
//           amount = inputtedValue;
//         } else {
//           amount = null;
//         }
//       });
//     }

//     if (textField == TextFieldFocus.period) {
//       setState(() {
//         if (inputtedValue > 0) {
//           period = inputtedValue;
//         } else {
//           period = null;
//         }
//       });
//     }

//     if (textField == TextFieldFocus.interestRate) {
//       setState(() {
//         if (inputtedValue > 0) {
//           rate = inputtedValue;
//         } else {
//           rate = null;
//         }
//       });
//     }

//     if (textField == TextFieldFocus.stepUp) {
//       setState(() {
//         if (inputtedValue > 0) {
//           stepUpPercentage = inputtedValue;
//         } else {
//           stepUpPercentage = null;
//         }
//       });
//     }
//   }

//   _onFocusChange(TextFieldFocus? textField, bool value) {
//     if (value == true) {
//       setState(() {
//         currentFocus = textField;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//         appBar: appBar(title: widget.title, context: context),
//         body: GestureDetector(
//             onTap: () {
//               FocusScopeNode currentFocus = FocusScope.of(context);
//               if (!currentFocus.hasPrimaryFocus) {
//                 currentFocus.unfocus();
//               }
//               if (this.currentFocus != null) {
//                 setState(() {
//                   this.currentFocus = null;
//                 });
//               }
//             },
//             child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
//                       child: Text(
//                         "Personal information",
//                         style: appTheme.textTheme.subtitle1,
//                       ),
//                     ),
//                     buildPersonalInformationContainer(context),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
//                       child: Text(
//                         "Investment information",
//                         style: appTheme.textTheme.subtitle1,
//                       ),
//                     ),
//                     buildInvestmentInformationContainer(context),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CupertinoButton(
//                             child: Text("Calculate"),
//                             // padding: EdgeInsets.all(16),
//                             borderRadius: BorderRadius.all(Radius.circular(8)),
//                             color: Colors.blue,
//                             disabledColor: Colors.grey,
//                             onPressed: isAllInputValid()
//                                 ? () {
//                                     _calculateSIP();
//                                     FocusScopeNode currentFocus =
//                                         FocusScope.of(context);
//                                     if (!currentFocus.hasPrimaryFocus) {
//                                       currentFocus.unfocus();
//                                     }
//                                   }
//                                 : null,
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                   ],
//                 ))));
//   }

//   Widget buildPersonalInformationContainer(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;
//     return Container(
//         width: deviceWidth,
//         padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
//         margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(1, 1), // changes position of shadow
//             )
//           ],
//         ),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           // _ageSection(context),
//           // SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                   width: (deviceWidth - 64) / 2, child: _ageSection(context)),
//               Container(
//                   width: (deviceWidth - 64) / 2,
//                   child: _retirementAgeSection(context))
//             ],
//           ),
//           SizedBox(height: 10),
//           _lifeExpectancy(context),
//           SizedBox(height: 10),
//           _currentHouseHoldExpenses(context),
//         ]));
//   }

//   Widget buildInvestmentInformationContainer(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;
//     return Container(
//         width: deviceWidth,
//         padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
//         margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(1, 1), // changes position of shadow
//             )
//           ],
//         ),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           _currentInvestments(context),
//           SizedBox(height: 20),
//           _returnRateOnInvestments(context),
//           SizedBox(height: 20),
//           _returnOnRetirementCorpus(context),
//           SizedBox(height: 20),
//           _inflationRate(context),
//           SizedBox(height: 20),
//         ]));
//   }

//   Widget _currentInvestments(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "10000000",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.amount,
//         currentFocus: currentFocus,
//         textLimit: 2);
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Your current investments",
//             style: appTheme.textTheme.caption,
//           ),
//           SizedBox(height: 5),
//           TextFieldContainer(containerData: data)
//         ]);
//   }

//   Widget _returnRateOnInvestments(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "12",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.amount,
//         currentFocus: currentFocus,
//         textLimit: periodTextLimit);
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Expected return on investments",
//             style: appTheme.textTheme.caption,
//           ),
//           SizedBox(height: 5),
//           TextFieldContainer(containerData: data)
//         ]);
//   }

//   Widget _returnOnRetirementCorpus(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "8",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.amount,
//         currentFocus: currentFocus,
//         textLimit: periodTextLimit);
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Expected return on retirement corpus (%)",
//             style: appTheme.textTheme.caption,
//           ),
//           SizedBox(height: 5),
//           TextFieldContainer(containerData: data)
//         ]);
//   }

//   Widget _ageSection(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "30",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.period,
//         currentFocus: currentFocus,
//         textLimit: 2);
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         "Your current age",
//         style: appTheme.textTheme.caption,
//       ),
//       SizedBox(height: 3),
//       TextFieldContainer(containerData: data)
//     ]);
//   }

//   Widget _retirementAgeSection(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "60",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.interestRate,
//         currentFocus: currentFocus,
//         textLimit: 2);
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         "Retirement age",
//         style: appTheme.textTheme.caption,
//       ),
//       SizedBox(height: 5),
//       TextFieldContainer(
//         containerData: data,
//       )
//     ]);
//   }

//   Widget _lifeExpectancy(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "85",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.stepUp,
//         currentFocus: currentFocus,
//         textLimit: periodTextLimit);
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         "Life expectancy",
//         style: appTheme.textTheme.caption,
//       ),
//       SizedBox(height: 5),
//       TextFieldContainer(
//         containerData: data,
//       )
//     ]);
//   }

//   Widget _currentHouseHoldExpenses(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "500000",
//         onTextChange: _onTextChange,
              //onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.stepUp,
//         currentFocus: currentFocus,
//         textLimit: 10);
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         "Current household expenses",
//         style: appTheme.textTheme.caption,
//       ),
//       SizedBox(height: 5),
//       TextFieldContainer(
//         containerData: data,
//       )
//     ]);
//   }

//   Widget _inflationRate(BuildContext context) {
//     TextFieldContainerData data = TextFieldContainerData(
//         placeHolder: "6",
//         onTextChange: _onTextChange,
             // onDoneButtonTapped: _onDoneButtonTapped,
//         onFocusChanged: _onFocusChange,
//         textField: TextFieldFocus.stepUp,
//         currentFocus: currentFocus,
//         textLimit: 2);
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         "Expected inflation rate (%)",
//         style: appTheme.textTheme.caption,
//       ),
//       SizedBox(height: 5),
//       TextFieldContainer(
//         containerData: data,
//       )
//     ]);
//   }

//   double _getGainPercentage() {
//     if ((wealthGain ?? 0) < 0) {
//       return 0;
//     }
//     if (corpusAmount?.isInfinite ?? false) {
//       return 100;
//     }
//     return (wealthGain ?? 0) / (corpusAmount ?? 0) * 100;
//   }

//   double _getInvestmentPercentage() {
//     if ((investedAmount ?? 0) < 0) {
//       return 0;
//     }
//     return (investedAmount ?? 0) / (corpusAmount ?? 0) * 100;
//   }
// }
