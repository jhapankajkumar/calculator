import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildSummeryContainer(
    {required BuildContext context,
    required String expectedAmountTitle,
    required String investedAmountTitle,
    required String wealthGainTitle,
    double? totalExpectedAmount,
    double? totalInvestedAmount,
    double? totalGainAmount,
    bool? isDetail,
    Function? onTapDetail}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  final formatter = new NumberFormat("#,###");
  var container = Container();
  if (totalGainAmount != null) {
    container = Container(
      width: deviceWidth,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: appTheme.primaryColor,
      ),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: appTheme.accentColor,
                padding: EdgeInsets.all(8),
                width: deviceWidth,
                child: Text(
                  "Summary",
                  style: appTheme.textTheme.bodyText1,
                ),
              ),
              //summery

              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  // Expected Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            expectedAmountTitle,
                            style: subTitle1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: totalExpectedAmount?.isInfinite == false
                              ? Text(
                                  '\$${formatter.format(totalExpectedAmount)}',
                                  style: subTitle2)
                              : Text('\$INFINITE', style: subTitle2),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: appTheme.accentColor,
                  ),
                  // Invested Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(investedAmountTitle, style: subTitle1),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          tileColor: Colors.grey[300],
                          title: totalInvestedAmount?.isInfinite == false
                              ? Text(
                                  '\$${formatter.format(totalInvestedAmount)}',
                                  style: subTitle2)
                              : Text('\$INFINITE', style: subTitle2),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: appTheme.accentColor,
                  ),
                  // Wealth Gain/Lost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(wealthGainTitle),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: totalGainAmount.isInfinite == false
                              ? Text(
                                  '\$${formatter.format(totalGainAmount)}',
                                  style: subTitle2,
                                )
                              : Text('\$INFINITE', style: subTitle2),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: appTheme.accentColor,
                  ),
                  SizedBox(height: 30),
                  isDetail != null
                      ? CupertinoButton(
                          child: Text("Detail"),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: appTheme.accentColor,
                          disabledColor: Colors.grey,
                          onPressed: () {
                            if (onTapDetail != null) {
                              onTapDetail();
                            }
                          },
                        )
                      : Container(),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  return container;
}
