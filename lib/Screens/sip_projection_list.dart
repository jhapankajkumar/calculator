import 'dart:math';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class SIPProjetionList extends StatefulWidget {
  final SIPResultData data;
  SIPProjetionList(this.data);
  @override
  _SIPProjetionListState createState() => _SIPProjetionListState();
}

class _SIPProjetionListState extends State<SIPProjetionList> {
  final formatter = new NumberFormat("##,###");
  int _currentSelection = 0;
  int _currentSelectedYear = 0;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Investment Detail", context: context),
        body: baseContainer(
            context: context,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialSegmentedControl(
                    children: {
                      0: Text(
                        '          Chart          ',
                        style: TextStyle(
                            color: (this._currentSelection == 0
                                ? Colors.white
                                : appTheme.accentColor)),
                      ),
                      1: Text(
                        '          Table          ',
                        style: TextStyle(
                            color: (this._currentSelection == 1
                                ? Colors.white
                                : appTheme.accentColor)),
                      ),
                    },
                    selectionIndex: _currentSelection,
                    borderColor: appTheme.primaryColor,
                    selectedColor: appTheme.accentColor,
                    unselectedColor: appTheme.primaryColor,
                    horizontalPadding: EdgeInsets.all(16),
                    verticalOffset: 16,
                    borderRadius: 32.0,
                    disabledColor: appTheme.primaryColor,
                    onSegmentChosen: (int index) {
                      setState(() {
                        _currentSelection = index;
                      });
                    },
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  _currentSelection == 0
                      ? Container()
                      : Expanded(child: buildT(context)),
                ],
              ),
            )));
  }

  Widget buildT(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return StickyHeader(
              header: buildTableHeader(), content: buildTableContent(context));
        },
      ),
    );
  }

  Widget buildTableContent(BuildContext context) {
    List<Widget> children = [];
    int? limit = (widget.data.list?.length ?? 0) > 100
        ? 100
        : (widget.data.list?.length ?? 0);
    for (int i = 0; i < (limit); i++) {
      var data = widget.data.list?[i];
      if (data != null) {
        children.add(buildContent(context, data, i));
      }
    }

    return Column(
      children: <Widget>[
        Card(
          child: Container(
              child: Column(
            children: children,
          )),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, SIPData data, int index) {
    double width = MediaQuery.of(context).size.width;
    double rowHeight = 80;
    List<Widget> children = [];
    for (int i = 0; i < (data.list?.length ?? 0); i++) {
      var detailData = data.list?[i];
      if (detailData != null) {
        children.add(buildDetailContent(context, detailData, i));
        children.add(Container(
          height: 1,
          color: Colors.grey,
        ));
      }
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (data.isExpanded == false) {
            data.isExpanded = true;
          } else {
            data.isExpanded = false;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: index == 0
                ? appTheme.secondaryHeaderColor
                : (index % 2 == 0 ? appTheme.primaryColor : Colors.white)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    width: width / 4 + 20,
                    height: rowHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('assets/images/expand.png'),
                          width: 16,
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Center(
                            child: Text(
                              "${(data.tenor?.toInt())} Years",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: caption2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Flexible(
                      child: Text(
                        "\$${data.amount?.toInt() ?? 0}",
                        textAlign: TextAlign.center,
                        style: caption2,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: rowHeight,
                    width: width / 4,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Center(
                        child: Text(
                          "\$${data.interest?.toInt() ?? 0}",
                          textAlign: TextAlign.center,
                          style: caption2,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: rowHeight,
                    width: width / 4,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Center(
                      child: Text(
                        '\$${k_m_b_generator(data.totalBalance ?? 0)}',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        style: caption2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            data.isExpanded == false
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: appTheme.accentColor, width: 1),
                    ),
                    child: Column(
                      children: children,
                    )),
          ],
        ),
      ),
    );
  }

  Widget buildDetailContent(BuildContext context, SIPData data, int index) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(color: appTheme.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: width / 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Month ${(data.tenor?.toInt())} ",
                  textAlign: TextAlign.center,
                  style: caption2,
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    "\$${data.amount?.toInt() ?? 0}",
                    textAlign: TextAlign.center,
                    style: caption3,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    "\$${data.amount?.toInt() ?? 0}",
                    textAlign: TextAlign.center,
                    style: caption3,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: Colors.grey,
            ),
            Flexible(
              child: Container(
                width: width / 4,
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  '\$${k_m_b_generator(data.totalBalance ?? 0)}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: caption3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTableHeader() {
    return Container(
      color: appTheme.primaryColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                "Duration",
                style: appTheme.textTheme.caption,
              ),
            ),
          ),
          Center(
            child: Text("Amount", style: appTheme.textTheme.caption),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              "Interest",
              style: appTheme.textTheme.caption,
            ),
          )),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Text(
                "Balance",
                style: appTheme.textTheme.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  String k_m_b_generator(double num) {
    if (num.isInfinite == true) {
      return "INFINITE";
    }
    if (num < 999999999999999) {
      return "${formatter.format(num)}";
    } else {
      return num.roundToDouble().toString();
    }
  }
}
