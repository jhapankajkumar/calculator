import 'dart:io';
import 'dart:typed_data';

import 'package:calculator/util/Components/directory.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io' show Platform;

Future<File> createPDF(
    BuildContext buildContext, InvestmentResult data, Screen category) async {
  var file = await localFile('GrowFundCalculator', 'pdf');
  var pdf = pw.Document();
  var imageData = await getImageData();
  if (imageData != null) {
    var image = pw.MemoryImage(imageData);
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Image(image),
      ); // Center
    }));
  }

  pw.Font? ttf;
  final font = await rootBundle.load("assets/fonts/Oxygen-Regular.ttf");
  ttf = pw.Font.ttf(font);
  double pageCount = data.tenor / 12;

  if (pageCount >= 1) {
    for (int i = 0; i < pageCount; i++) {
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.fromLTRB(16, 70, 16, 16),
          build: (pw.Context context) {
            return pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  buildPDFTableContent(buildContext, data, ttf, i, category),
                  pw.SizedBox(height: 50),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [getText(ttf), UrlText("GrowFund")]),
                ]);
          }));
    }
  } else {
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(16, 70, 16, 16),
        build: (pw.Context context) {
          return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                buildPDFTableBelowOneYear(buildContext, data, ttf, category),
                pw.SizedBox(height: 50),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [getText(ttf), UrlText("GrowFund")]),
              ]);
        }));
  }

  return file.writeAsBytes(await pdf.save());
}

pw.Widget buildPDFTableBelowOneYear(BuildContext context, InvestmentResult data,
    pw.Font? font, Screen category) {
  List<pw.Widget> children = [];
  children.add(buildPdfTableHeader(context, font, category));
  for (int i = 0; i < (data.tenor); i++) {
    var ldata = data.list?[i];
    if (ldata != null) {
      children.add(buildPDFContent(context, ldata, i, font, category));
      children.add(pw.SizedBox(height: 10));
    }
  }

  return pw.Container(
      child: pw.Column(
    children: children,
  ));
}

pw.Widget buildPDFTableContent(BuildContext context, InvestmentResult data,
    pw.Font? font, int index, Screen category) {
  List<pw.Widget> children = [];
  children.add(buildPdfTableHeader(context, font, category));
  for (int i = (index * 12); i < (index + 1) * 12; i++) {
    if (i < (data.list?.length ?? 0)) {
      var ldata = data.list?[i];
      children.add(buildPDFContent(context, ldata, i, font, category));
      children.add(pw.SizedBox(height: 10));
    }
  }

  return pw.Container(
      child: pw.Column(
    children: children,
  ));
}

pw.Widget buildPDFContent(BuildContext context, InvestmentData? data, int index,
    pw.Font? ttf, Screen category) {
  pw.TextStyle style = pw.TextStyle(
      fontSize: 12,
      font: ttf,
      fontWeight: pw.FontWeight.normal,
      color: PdfColor.fromHex("212E51"));
  double rowHeight = 40;
  bool isYear = false;
  String durationText = "";
  if (category == Screen.fd ||
      category == Screen.fv ||
      category == Screen.lumpsum) {
    durationText = '${data?.tenor} Year';
  } else {
    if ((index + 1) % 12 == 0) {
      isYear = true;
      durationText = '${(data?.tenor ?? 0) ~/ 12} Year';
    } else {
      durationText = '${(data?.tenor ?? 0)} Month';
      isYear = false;
    }
  }

  bool isSwp = false;
  if (category == Screen.swp) {
    isSwp = true;
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
              child: pw.Text("\$${k_m_b_generator(data?.amount ?? 0)}",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          )),
          isSwp
              ? pw.Flexible(
                  child: pw.Container(
                  height: rowHeight,
                  // width: width / 4,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: pw.Center(
                      child: pw.Text(
                          "\$${k_m_b_generator(data?.withdrawal ?? 0)}",
                          textAlign: pw.TextAlign.left,
                          style: style),
                    ),
                  ),
                ))
              : pw.Container(),
          pw.Flexible(
              child: pw.Container(
            height: rowHeight,
            // width: width / 4,
            child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: pw.Center(
                child: pw.Text("\$${k_m_b_generator(data?.profit ?? 0)}",
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
                      child: pw.Text('\$${k_m_b_generator(data?.balance ?? 0)}',
                          textAlign: pw.TextAlign.left,
                          overflow: pw.TextOverflow.clip,
                          style: style),
                    ),
                  ))),
        ]),
      ]));
}

pw.Widget buildPdfTableHeader(
    BuildContext context, pw.Font? ttf, Screen category) {
  pw.TextStyle style = pw.TextStyle(
      fontSize: captionFontSize,
      font: ttf,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("FFFFFF"));
  bool isSwp = false;
  if (category == Screen.swp) {
    isSwp = true;
  }
  return pw.Container(
    color: PdfColor.fromHex('212E51'),
    height: 60,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        pw.Expanded(
          child: pw.Center(
            child: pw.Text(
              isSwp ? "Time" : "Duration",
              textAlign: pw.TextAlign.left,
              style: style,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Center(
            child: pw.Text(isSwp ? "Start\nBalance" : "Amount",
                textAlign: pw.TextAlign.left, style: style),
          ),
        ),
        isSwp
            ? pw.Expanded(
                child: pw.Center(
                  child: pw.Text("Withdrawal",
                      textAlign: pw.TextAlign.left, style: style),
                ),
              )
            : pw.Container(),
        pw.Expanded(
          child: pw.Center(
              child: pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: pw.Text(
              isSwp ? "Interest\nEarned" : "Interest",
              textAlign: pw.TextAlign.left,
              style: style,
            ),
          )),
        ),
        pw.Expanded(
          child: pw.Center(
            child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: pw.Text(isSwp ? "End\nBalance" : "Balance",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget getText(pw.Font? ttf) {
  return pw.RichText(
    text: pw.TextSpan(
      style: pw.TextStyle(
          fontSize: 12,
          font: ttf,
          fontWeight: pw.FontWeight.normal,
          color: PdfColor.fromHex("212E51")),
      text: "Provided by ",
    ),
  );
}
//https://apps.apple.com/us/app/growfund/id1570488777
//https://play.google.com/store/apps/details?id=com.appstack.fincal

class UrlText extends pw.StatelessWidget {
  UrlText(this.text);
  final String text;

  String getUrl() {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.appstack.fincal';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/us/app/growfund/id1570488777';
    }
    return "";
  }

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: getUrl(),
      child: pw.Text(text,
          style: pw.TextStyle(
            //decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}
