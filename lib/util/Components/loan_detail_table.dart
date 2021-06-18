import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class InstallmentListTableView extends StatefulWidget {
  const InstallmentListTableView({
    Key? key,
    required this.data,
    required this.category,
  }) : super(key: key);
  final EMIData data;
  final Screen category;
  @override
  _InstallmentListTableViewState createState() =>
      _InstallmentListTableViewState();
}

class _InstallmentListTableViewState extends State<InstallmentListTableView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildT(context),
    );
  }

  double rowHeight = 80;
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
    int? limit = (widget.data.installments.length);
    for (int i = 0; i < (limit); i++) {
      var data = widget.data.installments[i];
      children.add(buildContent(context, data, i));
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

  Widget buildContent(BuildContext context, InstalmentData data, int index) {
    bool isYear = false;
    String durationText = "";
    double width = MediaQuery.of(context).size.width;
    double rowHeight = 80;
    if (widget.category == Screen.fv ||
        widget.category == Screen.fd ||
        widget.category == Screen.lumpsum) {
      durationText = '${data.tenor} Year';
    } else {
      if ((index + 1) % 12 == 0) {
        isYear = true;
        durationText = '${(data.tenor) ~/ 12}\nYear(s)';
      } else {
        durationText = '${(data.tenor)}\nMonth(s)';
        isYear = false;
      }
    }

    return Container(
      decoration: BoxDecoration(
          color: isYear == true
              ? appTheme.accentColor
              : (index % 2 == 0 ? appTheme.primaryColor : Colors.white)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Container(
                  width: width / 4,
                  height: rowHeight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Text(
                        "$durationText",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: isYear ? captionHeader : caption2,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Text(
                      "\$${k_m_b_generator(data.principalAmount)}",
                      textAlign: TextAlign.center,
                      style: isYear ? captionHeader : caption2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Flexible(
                child: Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Text(
                      "\$${k_m_b_generator(data.interestAmount)}",
                      textAlign: TextAlign.center,
                      style: isYear ? captionHeader : caption3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Flexible(
                child: Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Text(
                      "\$${k_m_b_generator(data.emiAmount)}",
                      textAlign: TextAlign.center,
                      style: isYear ? captionHeader : caption2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Flexible(
                child: Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Text(
                      '\$${k_m_b_generator(data.remainingLoanBalance)}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: isYear ? captionHeader : caption3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: appTheme.accentColor,
        height: 80,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: getHeaderChild()),
      ),
    );
  }

  List<Widget> getHeaderChild() {
    double width = MediaQuery.of(context).size.width;
    List<Widget> children = [];
    var duration = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Time",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var principal = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Principal\n(A)",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var interest = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Interest\n(B)",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));

    var total = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Total Payment\n(A + B)",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var balance = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Balance",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    children.add(duration);
    children.add(principal);
    children.add(interest);
    children.add(total);
    children.add(balance);
    return children;
  }
}
