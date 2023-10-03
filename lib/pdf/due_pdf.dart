import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_pos/model/due_transaction_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import '../const_commas.dart';
import '../model/personal_information_model.dart';
import '';

Future<File> createAndSaveDuePDF({required DueTransactionModel transactions, required PersonalInformationModel personalInformation, required BuildContext context}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      margin: pw.EdgeInsets.zero,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20.0),
          child: pw.Column(
            children: [
              pw.Row(children: [
                // pw.Container(
                //   height: 50.0,
                //   width: 50.0,
                //   alignment: pw.Alignment.centerRight,
                //   margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                //   padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                //   decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
                // ),
                pw.SizedBox(width: 10.0),
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(
                    personalInformation.companyName!,
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Tel: ${personalInformation.phoneNumber!}',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
                  ),
                ]),
              ]),
              pw.SizedBox(height: 30.0),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Container(
                    height: 40.0,
                    color: PdfColors.blueAccent,
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
                  child: pw.Text(
                    'Invoice/Bill',
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                pw.Container(
                  height: 40.0,
                  color: PdfColors.blueAccent,
                  width: 100,
                ),
              ]),
              pw.SizedBox(height: 30.0),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Column(children: [
                  pw.Row(children: [
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Bill To',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10.0,
                      child: pw.Text(
                        ':',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        transactions.customerName,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Phone',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10.0,
                      child: pw.Text(
                        ':',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        transactions.customerPhone,
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                  ]),
                ]),
                pw.Column(children: [
                  pw.Row(children: [
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Sells By',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10.0,
                      child: pw.Text(
                        ':',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Admin',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Invoice Number',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10.0,
                      child: pw.Text(
                        ':',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        '#${transactions.invoiceNumber}',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        'Date',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10.0,
                      child: pw.Text(
                        ':',
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                    pw.SizedBox(
                      width: 100.0,
                      child: pw.Text(
                        DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
                        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                      ),
                    ),
                  ]),
                ]),
              ]),
            ],
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Column(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                child: pw.Column(children: [
                  pw.Container(
                    width: 120.0,
                    height: 2.0,
                    color: PdfColors.black,
                  ),
                  pw.SizedBox(height: 4.0),
                  pw.Text(
                    'Customer Signature',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                  )
                ]),
              ),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                child: pw.Column(children: [
                  pw.Container(
                    width: 120.0,
                    height: 2.0,
                    color: PdfColors.black,
                  ),
                  pw.SizedBox(height: 4.0),
                  pw.Text(
                    'Authorized Signature',
                    style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
                  )
                ]),
              ),
            ]),
          ),
          pw.Container(
            width: double.infinity,
            color: PdfColors.blueAccent,
            padding: const pw.EdgeInsets.all(10.0),
            child: pw.Center(child: pw.Text('Powered By Smart Biashara', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
          ),
        ]);
      },
      build: (pw.Context context) => <pw.Widget>[
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: pw.Column(
            children: [
              pw.Table.fromTextArray(
                  context: context,
                  border: const pw.TableBorder(
                      left: pw.BorderSide(
                        color: PdfColors.blueAccent,
                      ),
                      right: pw.BorderSide(
                        color: PdfColors.blueAccent,
                      ),
                      bottom: pw.BorderSide(
                        color: PdfColors.blueAccent,
                      )),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.blueAccent,
                  ),
                  columnWidths: <int, pw.TableColumnWidth>{
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(6),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(2),
                    4: const pw.FlexColumnWidth(2),
                  },
                  headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                  rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
                  oddRowDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
                  headerAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.centerRight,
                    4: pw.Alignment.centerRight,
                  },
                  cellAlignments: <int, pw.Alignment>{
                    0: pw.Alignment.center,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.center,
                    3: pw.Alignment.centerRight,
                    4: pw.Alignment.centerRight,
                  },
                  data: <List<String>>[
                    <String>['SL', 'Item', '', '', 'Total Due'],

                    <String>[('${1}'), ('Due'), (''), (''), (myFormat.format(transactions.totalDue))],
                    // for (int i = 0; i < transactions.productList!.length; i++)
                    //   <String>[
                    //     ('${i + 1}'),
                    //     (transactions.productList!.elementAt(i).productName.toString()),
                    //     (transactions.productList!.elementAt(i).quantity.toString()),
                    //     (transactions.productList!.elementAt(i).subTotal),
                    //     ((int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString())
                    //   ],
                  ]),
              pw.Paragraph(text: ""),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.SizedBox(height: 10.0),
                      pw.Text(
                        "Subtotal: ${myFormat.format(transactions.totalDue)}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        "Discount: ${0.0}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Container(
                        color: PdfColors.blueAccent,
                        padding: const pw.EdgeInsets.all(5.0),
                        child: pw.Text("Total Due: ${myFormat.format(transactions.totalDue)}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Container(
                        width: 540,
                        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          pw.Text(
                            "Paid Via: ${transactions.paymentType}",
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            "Paid Amount: ${myFormat.format(transactions.totalDue!.toDouble() - transactions.dueAmountAfterPay!.toDouble())}",
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        "Still Due: ${myFormat.format(transactions.dueAmountAfterPay)}",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10.0),
                    ],
                  ),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.all(10)),
            ],
          ),
        ),
      ],
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/smart_biashara_due_${transactions.invoiceNumber}.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}

void shareDuePDF({required DueTransactionModel transactions, required PersonalInformationModel personalInformation, required BuildContext context}) async {
  final pdfFile = await createAndSaveDuePDF(context: context, personalInformation: personalInformation, transactions: transactions);
  Share.shareFiles([pdfFile.path], text: 'Share PDF');
}
