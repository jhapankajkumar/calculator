import 'dart:io';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import 'directory.dart';

class ExcelSheetCreator {
  static final ExcelSheetCreator shared = ExcelSheetCreator._internal();
  factory ExcelSheetCreator() {
    return shared;
  }

  ExcelSheetCreator._internal();

  CellStyle cellHeaderStyle = CellStyle(
    bold: true,
    backgroundColorHex: '#212E51',
    fontColorHex: '#FFFFFF',
    horizontalAlign: HorizontalAlign.Right,
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
    var isFutureValue = false;
    if (category == Screen.fv ||
        category == Screen.fd ||
        category == Screen.lumpsum) {
      isFutureValue = true;
    } else {
      isFutureValue = false;
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

  Future<File?> createEMIDetailSheet(
      BuildContext buildContext, EMIData data, Screen category) async {
    //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
    //var bytes = File(file).readAsBytesSync();
    var file = await localFile('GrowFundCalculator', 'xlsx');
    var excel = Excel.createExcel();

    /// deleting the sheet
    excel.delete('Sheet');

    var sheet = excel['Sheet1'];

    sheet = updateLoanHeader(sheet);

    // appending rows and checking the time complexity of it
    data.installments.forEach((element) {
      List<dynamic> row = [];
      row.add('${(element.tenor)} Month(s)');
      row.add(element.principalAmount.roundToDouble());
      row.add(element.interestAmount.roundToDouble());
      row.add(element.emiAmount.roundToDouble());
      row.add(element.remainingLoanBalance.roundToDouble());
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

  Sheet updateLoanHeader(Sheet sheet) {
    var cell = sheet.cell(CellIndex.indexByString("A1"));
    cell.value = "Time";
    cell.cellStyle = cellHeaderStyle;

    var cell3 = sheet.cell(CellIndex.indexByString("B1"));
    cell3.value = "Principal\n(A)";
    cell3.cellStyle = cellHeaderStyle;

    var cell5 = sheet.cell(CellIndex.indexByString("C1"));
    cell5.value = "Interest\n(B)";
    cell5.cellStyle = cellHeaderStyle;

    var cell7 = sheet.cell(CellIndex.indexByString("D1"));
    cell7.value = "Total Payment\n(A + B)";
    cell7.cellStyle = cellHeaderStyle;

    var cell9 = sheet.cell(CellIndex.indexByString("E1"));
    cell9.value = 'Balance';
    cell9.cellStyle = cellHeaderStyle;

    return sheet;
  }
}
