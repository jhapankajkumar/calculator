import 'dart:io';
import 'dart:typed_data';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  print('PATH $path');
  var file = File('$path/detail.pdf');
  return file;
}

Future<File> get imagePath async {
  final path = await localPath;
  var file = File('$path/chart.png');
  return file;
}

Future<File> createPDF(BuildContext buildContext, SIPResultData data) async {
  var file = await localFile;
  var pdf = pw.Document();
  var imageFilePath = await imagePath;

  var isExist = await imageFilePath.exists();
  if (isExist) {
    var image = pw.MemoryImage(
      imageFilePath.readAsBytesSync(),
    );
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    }));
  }

  pw.Font? ttf;
  final font = await rootBundle.load("assets/fonts/Oxygen-Regular.ttf");
  ttf = pw.Font.ttf(font);
  List<pw.Widget> pages = [];
  double pageCount = data.tenor / 12;
  for (int i = 0; i < pageCount; i++) {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(16, 150, 16, 16),
        build: (pw.Context context) {
          return pw.Center(
              child:
                  buildPDFTableContent(buildContext, data, ttf, i)); // Center
        }));
  }

  return file.writeAsBytes(await pdf.save());
}

pw.Widget buildPDFTableContent(
    BuildContext context, SIPResultData data, pw.Font? font, int index) {
  List<pw.Widget> children = [];
  children.add(buildPdfTableHeader(context, font));
  for (int i = (index * 12); i < (index + 1) * 12; i++) {
    var ldata = data.list?[i];
    if (ldata != null) {
      children.add(buildPDFContent(context, ldata, i, font));
      children.add(pw.SizedBox(height: 10));
    }
  }

  return pw.Container(
      child: pw.Column(
    children: children,
  ));
}

pw.Widget buildPDFContent(
    BuildContext context, SIPData data, int index, pw.Font? ttf) {
  pw.TextStyle style = pw.TextStyle(
      fontSize: captionFontSize,
      font: ttf,
      fontWeight: pw.FontWeight.normal,
      color: PdfColor.fromHex("212E51"));
  double rowHeight = 40;
  bool isYear = false;
  String durationText = "";
  if ((index + 1) % 12 == 0) {
    isYear = true;
    durationText = '${(data.tenor ?? 0) ~/ 12} Year';
  } else {
    durationText = '${(data.tenor ?? 0)} Month';
    isYear = false;
  }

  PdfColor color = isYear == true
      ? PdfColor.fromHex("4B9EC8")
      : (index % 2 == 0
          ? PdfColor.fromHex('EFEFEF')
          : PdfColor.fromHex('CDDEEE'));
  return pw.Container(
      decoration: pw.BoxDecoration(color: color),
      child: pw.Column(children: [
        pw.Row(children: [
          pw.Flexible(
            child: pw.Container(
              height: rowHeight,
              child: pw.Row(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: pw.Center(
                      child: pw.Text(
                        "$durationText",
                        textAlign: pw.TextAlign.left,
                        overflow: pw.TextOverflow.clip,
                        style: style,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.Flexible(
              child: pw.Container(
            height: rowHeight,
            child: pw.Center(
              child: pw.Text("\$${k_m_b_generator(data.amount ?? 0)}",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          )),
          pw.Flexible(
              child: pw.Container(
            height: rowHeight,
            // width: width / 4,
            child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: pw.Center(
                child: pw.Text("\$${k_m_b_generator(data.interest ?? 0)}",
                    textAlign: pw.TextAlign.left, style: style),
              ),
            ),
          )),
          pw.Flexible(
              child: pw.Container(
                  height: rowHeight,
                  padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: pw.Expanded(
                    child: pw.Center(
                      child: pw.Text(
                          '\$${k_m_b_generator(data.totalBalance ?? 0)}',
                          textAlign: pw.TextAlign.left,
                          overflow: pw.TextOverflow.clip,
                          style: style),
                    ),
                  ))),
        ]),
      ]));
}

pw.Widget buildPdfTableHeader(BuildContext context, pw.Font? ttf) {
  pw.TextStyle style = pw.TextStyle(
      fontSize: captionFontSize,
      font: ttf,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("FFFFFF"));
  return pw.Container(
    color: PdfColor.fromHex('212E51'),
    height: 60,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        pw.Expanded(
          child: pw.Center(
            child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: pw.Text(
                "Duration",
                textAlign: pw.TextAlign.left,
                style: style,
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Center(
            child:
                pw.Text("Amount", textAlign: pw.TextAlign.left, style: style),
          ),
        ),
        pw.Expanded(
          child: pw.Center(
              child: pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: pw.Text(
              "Interest",
              textAlign: pw.TextAlign.left,
              style: style,
            ),
          )),
        ),
        pw.Expanded(
          child: pw.Center(
            child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: pw.Text("Balance",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          ),
        ),
      ],
    ),
  );
}
