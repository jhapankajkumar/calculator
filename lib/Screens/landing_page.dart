import 'package:calculator/Screens/emi_calculator.dart';
import 'package:calculator/Screens/sip_calculator.dart';
import 'package:calculator/Screens/target_amount_sip_calculator.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/image_constants.dart';
import 'package:calculator/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'fixed_deposite_calculator.dart';
import 'retirement_calclutator.dart';

class LandingPage extends StatefulWidget {
  final String title;
  LandingPage({required this.title});
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _sipClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SIPCalculator(
        isSteupUp: false,
        title: StringConstants.sipCalculator,
      );
    }));
  }

  void _stepUpSIPClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SIPCalculator(
        isSteupUp: true,
        title: StringConstants.incrementalSIPCalculator,
      );
    }));
  }

  void _futureValueClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return FixedDepositeCalculator(
          title: StringConstants.futureValueCalculator,
          isFixedDeposit: false,
        );
      }),
    );
  }

  void _fdClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return FixedDepositeCalculator(
        title: StringConstants.fixedDepositCalculator,
        isFixedDeposit: true,
      );
    }));
  }

  void _targetAmountClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TargetAmountSIPCalculator(
        title: StringConstants.targetAmountCalculator,
      );
    }));
  }

  // void _retirementClicked() {
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
  //     return RetirementCalculator(
  //       title: StringConstants.retirementCalcualtor,
  //       isSteupUp: false,
  //     );
  //   }));
  // }

  void _emiClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return EMICalculator(
        title: StringConstants.emiCalcualtor,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: new AppBar(
          title: new Text(
            StringConstants.calculator,
            style: appTheme.textTheme.bodyText2,
          ),
          backgroundColor: appTheme.primaryColor,
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          width: deviceWidth,
          height: deviceHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 8,
                blurRadius: 2,
                offset: Offset(1, 1), // changes position of shadow
              )
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                      //   child: Text(
                      //     "Systmatic Investmnt Planning",
                      //     style: appTheme.textTheme.subtitle1,
                      //   ),
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
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                      //   child: Text(
                      //     "Value of Your Money",
                      //     style: appTheme.textTheme.subtitle1,
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.futureValue,
                              ImageConstants.futureValue, _futureValueClicked),
                          buildSIPView(context, StringConstants.emi,
                              ImageConstants.emi, _emiClicked),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildSIPView(context, StringConstants.fixedDeposit,
                              ImageConstants.fd, _fdClicked),
                          buildSIPView(
                              context,
                              StringConstants.targetAmount,
                              ImageConstants.targetAmount,
                              _targetAmountClicked),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
        padding: EdgeInsets.all(10),
        width: 120,
        height: 120,
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
              width: 60,
              height: 60,
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
