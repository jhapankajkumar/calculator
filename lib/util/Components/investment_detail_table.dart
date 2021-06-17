import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class InvestmentListTableView extends StatefulWidget {
  const InvestmentListTableView({
    Key? key,
    required this.data,
    required this.category,
  }) : super(key: key);
  final InvestmentResult data;
  final Screen category;
  @override
  _InvestmentListTableViewState createState() =>
      _InvestmentListTableViewState();
}

class _InvestmentListTableViewState extends State<InvestmentListTableView> {
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
    int? limit = (widget.data.list?.length ?? 0) > 600
        ? 600
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

  Widget buildContent(BuildContext context, InvestmentData data, int index) {
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
                      "\$${k_m_b_generator(data.amount)}",
                      textAlign: TextAlign.center,
                      style: isYear ? captionHeader : caption3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              widget.category == Screen.swp
                  ? Flexible(
                      child: Container(
                        height: rowHeight,
                        width: width / 4,
                        child: Center(
                          child: Text(
                            "\$${k_m_b_generator(data.withdrawal ?? 0)}",
                            textAlign: TextAlign.center,
                            style: isYear ? captionHeader : caption3,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              widget.category == Screen.swp
                  ? SizedBox(
                      width: 2,
                    )
                  : Container(),
              Flexible(
                child: Container(
                  height: rowHeight,
                  width: width / 4,
                  child: Center(
                    child: Text(
                      "\$${k_m_b_generator(data.profit)}",
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
                      '\$${k_m_b_generator(data.balance)}',
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
            children: widget.category == Screen.swp
                ? getSwpHeaderChild()
                : getHeaderChild()),
      ),
    );
  }

  List<Widget> getHeaderChild() {
    double width = MediaQuery.of(context).size.width;
    List<Widget> children = [];
    var duration = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 4,
            child: Center(
              child: Text(
                "Duration",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var amount = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 4,
            child: Center(
              child: Text(
                "Amount",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var interest = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 4,
            child: Center(
              child: Text(
                "Interest",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var balance = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 4,
            child: Center(
              child: Text(
                "Balance",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    children.add(duration);
    children.add(amount);
    children.add(interest);
    children.add(balance);
    return children;
  }

  List<Widget> getSwpHeaderChild() {
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
    var amount = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Start\nBalance",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    var withdrawal = Flexible(
        child: Container(
            height: rowHeight,
            width: width / 5,
            child: Center(
              child: Text(
                "Withdrawal",
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
                "Interest",
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
                "End\nBalance",
                textAlign: TextAlign.center,
                style: captionHeader,
              ),
            )));
    children.add(duration);
    children.add(amount);
    children.add(withdrawal);
    children.add(interest);
    children.add(balance);
    return children;
  }
}
