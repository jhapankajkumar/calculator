import 'dart:io';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import 'directory.dart';

CellStyle cellHeaderStyle = CellStyle(
  bold: true,
  backgroundColorHex: '#212E51',
  fontColorHex: '#FFFFFF',
  textWrapping: TextWrapping.WrapText,
  fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
  rotation: 0,
);
CellStyle rowTextStyle = CellStyle(
  bold: true,
  backgroundColorHex: '#212E51',
  fontColorHex: '#FFFFFF',
  textWrapping: TextWrapping.WrapText,
  fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
  rotation: 0,
);
Future<File?> createExcel(
    BuildContext buildContext, InvestmentResult data, Screen category) async {
  //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
  //var bytes = File(file).readAsBytesSync();
  var file = await localFile('GrowFundCalculator', 'xlsx');
  var excel = Excel.createExcel();

  /// deleting the sheet
  excel.delete('Sheet');

  var sheet = excel['Sheet1'];
  if (category == Screen.swp) {
    sheet = updateSwpHeader(sheet, category);
  } else {
    sheet = updateNormalHeader(sheet, category);
  }

  // appending rows and checking the time complexity of it
  Stopwatch stopwatch = Stopwatch()..start();
  List<List<String>> list = List.generate(
      20, (index) => List.generate(20, (index1) => '$index $index1'));

  //print('list creation executed in ${stopwatch.elapsed}');
  // stopwatch.reset();
  // list.forEach((row) {
  //   print(row);
  //   //sheet.appendRow(row);
  // });
  var isFutureValue = false;
  if (category == Screen.fv ||
      category == Screen.fd ||
      category == Screen.lumpsum) {
    isFutureValue = true;
  } else {
    isFutureValue = false;
    // if ((index + 1) % 12 == 0) {
    //   isYear = true;
    //   durationText = '${(data.tenor) ~/ 12}\nYear(s)';
    // } else {
    //   durationText = '${(data.tenor)}\nMonth(s)';
    //   isYear = false;
    // }
  }
  var isSwp = false;
  if (category == Screen.swp) {
    isSwp = true;
  }
  data.list?.forEach((element) {
    List<dynamic> row = [];
    if (isFutureValue) {
      row.add('${element.tenor} Year');
    } else {
      // if ((index + 1) % 12 == 0) {
      //   isYear = true;
      //   durationText = '${(data.tenor) ~/ 12}\nYear(s)';
      // } else {
      //   durationText = '${(data.tenor)}\nMonth(s)';
      //   isYear = false;
      // }
      row.add('${(element.tenor)} Month(s)');
    }

    row.add(element.amount);
    if (isSwp) {
      row.add(element.withdrawal);
    }
    row.add(element.profit);
    row.add(element.balance);
    sheet.appendRow(row);
  });

  List<int>? fileBytes = excel.save();
  //print('saving executed in ${stopwatch.elapsed}');

  if (fileBytes != null) {
    return file.writeAsBytes(fileBytes);
  }
  return null;
}

Sheet updateNormalHeader(Sheet sheet, Screen category) {
  var cell = sheet.cell(CellIndex.indexByString("A1"));
  cell.value = "Duration";
  cell.cellStyle = cellHeaderStyle;

  var cell3 = sheet.cell(CellIndex.indexByString("B1"));
  cell3.value = "Amount";
  cell3.cellStyle = cellHeaderStyle;

  var cell5 = sheet.cell(CellIndex.indexByString("C1"));
  cell5.value = "Interest";
  cell5.cellStyle = cellHeaderStyle;

  var cell7 = sheet.cell(CellIndex.indexByString("D1"));
  cell7.value = "Balance";
  cell7.cellStyle = cellHeaderStyle;

  // var cell5 = sheet.cell(CellIndex.indexByString("E1"));
  // cell.value = "Duration";
  // cell.cellStyle = cellHeaderStyle;
  return sheet;

  /// printing cell-type
}

Sheet updateSwpHeader(Sheet sheet, Screen category) {
  var cell = sheet.cell(CellIndex.indexByString("A1"));
  cell.value = "Time";
  cell.cellStyle = cellHeaderStyle;

  var cell3 = sheet.cell(CellIndex.indexByString("B1"));
  cell3.value = "Start Balance";
  cell3.cellStyle = cellHeaderStyle;

  var cell5 = sheet.cell(CellIndex.indexByString("C1"));
  cell5.value = "Withdrawal";
  cell5.cellStyle = cellHeaderStyle;

  var cell7 = sheet.cell(CellIndex.indexByString("D1"));
  cell7.value = "Interest";
  cell7.cellStyle = cellHeaderStyle;

  var cell9 = sheet.cell(CellIndex.indexByString("E1"));
  cell9.value = 'End Balance';
  cell9.cellStyle = cellHeaderStyle;

  return sheet;
}
