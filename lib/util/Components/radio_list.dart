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

String getString(Compounding compounding) {
  switch (compounding) {
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
    hint: Text("Compounding"),
    items:
        compoundingList.map<DropdownMenuItem<Compounding>>((Compounding value) {
      return DropdownMenuItem<Compounding>(
          value: value, child: Text(getString(value)));
    }).toList(),
  );
}

// Widget buildRadioList(
//     {Compounding? compounding, required Function onOptionChange}) {
//   return Container(
//     padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.all(Radius.circular(8)),
//       color: appTheme.primaryColor,
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           'Compounding',
//           textAlign: TextAlign.center,
//           style: appTheme.textTheme.caption,
//         ),
//         ListTile(
//           title: Text('Monthly', style: appTheme.textTheme.caption),
//           horizontalTitleGap: 0,
//           leading: Radio<Compounding>(
//             value: Compounding.monthly,
//             groupValue: compounding,
//             onChanged: (Compounding? value) {
//               onOptionChange(value);
//             },
//           ),
//         ),
//         ListTile(
//           title: Text('Quaterly', style: appTheme.textTheme.caption),
//           horizontalTitleGap: 0,
//           leading: Radio<Compounding>(
//             value: Compounding.quaterly,
//             groupValue: compounding,
//             onChanged: (Compounding? value) {
//               onOptionChange(value);
//             },
//           ),
//         ),
//         ListTile(
//           title: Text('Annually', style: appTheme.textTheme.caption),
//           horizontalTitleGap: 0,
//           leading: Radio<Compounding>(
//             value: Compounding.annually,
//             groupValue: compounding,
//             onChanged: (Compounding? value) {
//               onOptionChange(value);
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget buildPeriodDropDown(Period? currentValue, Function onChanged) {
  return DropdownButton<Period>(
    value: currentValue,
    dropdownColor: appTheme.primaryColor,
    icon: const Icon(Icons.keyboard_arrow_down),
    iconSize: 24,
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
