import 'dart:io';

import 'package:calculator/util/Components/directory.dart';
import 'package:calculator/util/Components/pdf_table.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io' show Platform;

class LoanPDFCreator {
  static final LoanPDFCreator shared = LoanPDFCreator._internal();
  factory LoanPDFCreator() {
    return shared;
  }

  LoanPDFCreator._internal();
  Future<File> createLoanPDF(
      BuildContext buildContext, EMIData data, Screen category) async {
    var file = await localFile('GrowFundCalculator', 'pdf');
    var pdf = pw.Document();
    var imageData = await getImageData();

    //Check for valid png
    if (imageData != null) {
      PngDecoder png = PngDecoder();
      if (png.isValidFile(imageData)) {
        var image = pw.MemoryImage(imageData);
        pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          ); // Center
        }));
      }
    }

    pw.Font? ttf;
    final font = await rootBundle.load("assets/fonts/Oxygen-Regular.ttf");
    ttf = pw.Font.ttf(font);
    double pageCount = data.period / 12;

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

  pw.Widget buildPDFTableBelowOneYear(
      BuildContext context, EMIData data, pw.Font? font, Screen category) {
    List<pw.Widget> children = [];
    children.add(buildPdfTableHeader(context, font, category));
    for (int i = 0; i < (data.period); i++) {
      var ldata = data.installments[i];
      children.add(buildPDFContent(context, ldata, i, font, category));
      children.add(pw.SizedBox(height: 10));
    }

    return pw.Container(
        child: pw.Column(
      children: children,
    ));
  }

  pw.Widget buildPDFTableContent(BuildContext context, EMIData data,
      pw.Font? font, int index, Screen category) {
    List<pw.Widget> children = [];
    children.add(buildPdfTableHeader(context, font, category));
    for (int i = (index * 12); i < (index + 1) * 12; i++) {
      if (i < (data.installments.length)) {
        var ldata = data.installments[i];
        children.add(buildPDFContent(context, ldata, i, font, category));
        children.add(pw.SizedBox(height: 10));
      }
    }

    return pw.Container(
        child: pw.Column(
      children: children,
    ));
  }

  pw.Widget buildPDFContent(BuildContext context, InstalmentData? data,
      int index, pw.Font? ttf, Screen category) {
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
                child: pw.Text(
                    "\$${k_m_b_generator(data?.principalAmount ?? 0)}",
                    textAlign: pw.TextAlign.left,
                    style: style),
              ),
            )),
            pw.Flexible(
                child: pw.Container(
              height: rowHeight,
              child: pw.Center(
                child: pw.Text(
                    "\$${k_m_b_generator(data?.interestAmount ?? 0)}",
                    textAlign: pw.TextAlign.left,
                    style: style),
              ),
            )),
            pw.Flexible(
                child: pw.Container(
              height: rowHeight,
              // width: width / 4,
              child: pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: pw.Center(
                  child: pw.Text("\$${k_m_b_generator(data?.emiAmount ?? 0)}",
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
                            '\$${k_m_b_generator(data?.remainingLoanBalance.abs() ?? 0)}',
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
    return pw.Container(
      color: PdfColor.fromHex('212E51'),
      height: 60,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          pw.Expanded(
            child: pw.Center(
              child: pw.Text(
                "Time",
                textAlign: pw.TextAlign.left,
                style: style,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Center(
              child: pw.Text("Principal\n(A)",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          ),
          pw.Expanded(
            child: pw.Center(
              child: pw.Text("Interest\n(B)",
                  textAlign: pw.TextAlign.left, style: style),
            ),
          ),
          pw.Expanded(
            child: pw.Center(
                child: pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: pw.Text(
                "Total Payment\n(A + B)",
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
}
