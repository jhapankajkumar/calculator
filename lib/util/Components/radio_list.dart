import 'package:flutter/material.dart';

import '../Constants/constants.dart';

enum Compounding { monthly, quaterly, annually }
enum Period { months, years }

Widget buildRadioList(
    {Compounding? compounding, required Function onOptionChange}) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: appTheme.primaryColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Compounding',
          textAlign: TextAlign.center,
          style: appTheme.textTheme.caption,
        ),
        ListTile(
          title: Text('Monthly', style: appTheme.textTheme.caption),
          horizontalTitleGap: 0,
          leading: Radio<Compounding>(
            value: Compounding.monthly,
            groupValue: compounding,
            onChanged: (Compounding? value) {
              onOptionChange(value);
            },
          ),
        ),
        ListTile(
          title: Text('Quaterly', style: appTheme.textTheme.caption),
          horizontalTitleGap: 0,
          leading: Radio<Compounding>(
            value: Compounding.quaterly,
            groupValue: compounding,
            onChanged: (Compounding? value) {
              onOptionChange(value);
            },
          ),
        ),
        ListTile(
          title: Text('Annually', style: appTheme.textTheme.caption),
          horizontalTitleGap: 0,
          leading: Radio<Compounding>(
            value: Compounding.annually,
            groupValue: compounding,
            onChanged: (Compounding? value) {
              onOptionChange(value);
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildPeriodList(
    {Period? compounding, required Function onOptionChange}) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: appTheme.primaryColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Period',
          textAlign: TextAlign.center,
          style: appTheme.textTheme.caption,
        ),
        ListTile(
          title: Text('Years', style: appTheme.textTheme.caption),
          horizontalTitleGap: 0,
          leading: Radio<Period>(
            value: Period.years,
            groupValue: compounding,
            onChanged: (Period? value) {
              onOptionChange(value);
            },
          ),
        ),
        ListTile(
          title: Text('Months', style: appTheme.textTheme.caption),
          horizontalTitleGap: 0,
          leading: Radio<Period>(
            value: Period.months,
            groupValue: compounding,
            onChanged: (Period? value) {
              onOptionChange(value);
            },
          ),
        ),
      ],
    ),
  );
}
