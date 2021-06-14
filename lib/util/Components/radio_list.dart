import 'package:flutter/material.dart';

import '../Constants/constants.dart';

enum Compounding { monthly, quaterly, annually }
enum Period { years, months }

List<Period> periodList = [Period.years, Period.months];
List<Compounding> compoundingList = [
  Compounding.monthly,
  Compounding.quaterly,
  Compounding.annually
];

String getCompoundingTitle(Compounding? compounding) {
  switch (compounding ?? Compounding.monthly) {
    case Compounding.monthly:
      return "Monthly";
    case Compounding.quaterly:
      return "Quaterly";
    case Compounding.annually:
      return "Annually";
  }
}

Widget buildCompoundungDropDown(Compounding? currentValue, Function onChanged) {
  return DropdownButton<Compounding>(
    value: currentValue,
    dropdownColor: appTheme.primaryColor,
    icon: const Icon(Icons.keyboard_arrow_down),
    iconSize: 24,
    underline: Container(),
    //elevation: 16,
    style: appTheme.textTheme.caption,
    onChanged: (Compounding? newValue) {
      onChanged(newValue);
    },
    items:
        compoundingList.map<DropdownMenuItem<Compounding>>((Compounding value) {
      return DropdownMenuItem<Compounding>(
          value: value, child: Text(getCompoundingTitle(value)));
    }).toList(),
  );
}

Widget buildPeriodDropDown(Period? currentValue, Function onChanged) {
  return DropdownButton<Period>(
    value: currentValue,
    dropdownColor: appTheme.primaryColor,
    icon: const Icon(Icons.keyboard_arrow_down),
    iconSize: 24,
    underline: Container(),
    //elevation: 16,
    style: appTheme.textTheme.caption,
    onChanged: (Period? newValue) {
      onChanged(newValue);
    },
    items: periodList.map<DropdownMenuItem<Period>>((Period value) {
      return DropdownMenuItem<Period>(
          value: value,
          child: Text(value == Period.months ? "Months" : "Years"));
    }).toList(),
  );
}
