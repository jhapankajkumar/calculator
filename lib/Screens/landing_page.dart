import 'dart:io';

import 'package:calculator/Screens/emi_calculator.dart';
import 'package:calculator/Screens/sip_calculator.dart';
import 'package:calculator/Screens/swp_calculator.dart';
import 'package:calculator/Screens/target_amount_sip_calculator.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/image_constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fixed_deposite_calculator.dart';
import 'retirement_calclutator.dart';

class LandingPage extends StatefulWidget {
  Screen category;
  LandingPage({required this.category});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _sipClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SIPCalculator(
        category: Screen.sip,
      );
    }));
  }

  Future<void> _stepUpSIPClicked() async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SIPCalculator(
        category: Screen.stepup,
      );
    }));
  }

  void _futureValueClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return FixedDepositeCalculator(
          category: Screen.fv,
        );
      }),
    );
  }

  void _lumpsumClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return FixedDepositeCalculator(
          category: Screen.lumpsum,
        );
      }),
    );
  }

  void _swpClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return SWPCalculator(
          category: Screen.swp,
        );
      }),
    );
  }

  void _rdClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return SIPCalculator(
          category: Screen.rd,
        );
      }),
    );
  }

  void _fdClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return FixedDepositeCalculator(
        category: Screen.fd,
      );
    }));
  }

  void _targetAmountClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TargetAmountSIPCalculator(
        category: Screen.target,
      );
    }));
  }

  void _retirementClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RetirementCalculator(
        category: Screen.retirement,
      );
    }));
  }

  void _emiClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return EMICalculator(
        category: Screen.emi,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
            category: widget.category, context: context, isBackButton: false),
        body: baseContainer(
          context: context,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       child: Center(
                      //           child: Padding(
                      //         padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      //         child: Text("Investments"),
                      //       )),
                      //     )
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.sip,
                              ImageConstants.sip, _sipClicked),
                          buildSIPView(context, StringConstants.increamentalSIP,
                              ImageConstants.stepUpSIP, _stepUpSIPClicked)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.lumpsum,
                              ImageConstants.lumpsum, _lumpsumClicked),
                          buildSIPView(context, StringConstants.swp,
                              ImageConstants.swp, _swpClicked),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Container(
                      //   child: Padding(
                      //     padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      //     child: Text(
                      //       "Banking",
                      //       textAlign: TextAlign.start,
                      //     ),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.fixedDeposit,
                              ImageConstants.fd, _fdClicked),
                          buildSIPView(
                              context,
                              StringConstants.recurringDeposit,
                              ImageConstants.recurring,
                              _rdClicked),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.emi,
                              ImageConstants.emi, _emiClicked),
                          buildSIPView(context, StringConstants.futureValue,
                              ImageConstants.futureValue, _futureValueClicked),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.retirement,
                              ImageConstants.retirement, _retirementClicked),
                          buildSIPView(
                              context,
                              "Goal",
                              ImageConstants.targetAmount,
                              _targetAmountClicked),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ))),
        ));
  }

  Widget buildSIPView(
      BuildContext context, String title, String image, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: menuContainerSize,
        height: menuContainerSize,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: appTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
              spreadRadius: 8,
              blurRadius: 2,
              offset: Offset(1, 1), // changes position of shadow
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Image(
              image: AssetImage('assets/images/$image.png'),
              width: menuImageSize,
              height: menuImageSize,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: appTheme.textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}
