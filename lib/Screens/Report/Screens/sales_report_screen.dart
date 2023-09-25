import 'dart:async';
import 'dart:io';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import '../../../Functions/generate_pdf.dart';
import '../../../Functions/generate_pdf.dart';
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../../currency.dart';
import '../../../empty_screen_widget.dart';
import '../../../model/personal_information_model.dart';
import '../../../model/transition_model.dart';
import '../../Home/home.dart';
import '../../Pdf/pdf_view.dart';
import '../../invoice_details/sales_invoice_details_screen.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String? invoiceNumber;
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();
  double totalSell = 0;
  bool isPicked = false;
  int count = 0;

  final pw.Document doc = pw.Document();



  //
  // void shareFile()async{
  //    var file=await FilePicker.platform.pickFiles();
  //    Share.shareFiles([file!.paths[0]!]);
  // }
  //
  // sahreOnWhatsapp(TransitionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async{
  //   const downloadsFolderPath = '/storage/emulated/0/Download/';
  //   Directory dir = Directory(downloadsFolderPath);
  //   final file = File('${dir.path}/${'smart biashara-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');
  //   final byteData = await doc.save();
  //   await file.writeAsBytes(byteData);
  //
  //   if (downloadsFolderPath.isNotEmpty) {
  //   await WhatsappShare.shareFile(
  //   text: file.path,
  //    filePath: [file.path],
  //     phone: '01764972576',
  //   );
  //   }
  // }


  Future<pw.Document> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('${GeneratePdf()}'),
            // child: pw.Text('Hello Shakil'),
          );
        },
      ),
    );
    return pdf;
  }
  final pdf = pw.Document();
  // Future<File> generateAndSharePdf(TransitionModel transactions, PersonalInformationModel personalInformation, BuildContext context) async {
  //   final pdf = pw.Document();
  //   doc.addPage(
  //     pw.MultiPage(
  //       pageFormat: PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
  //       margin: pw.EdgeInsets.zero,
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       header: (pw.Context context) {
  //         return pw.Padding(
  //           padding: const pw.EdgeInsets.all(20.0),
  //           child: pw.Column(
  //             children: [
  //               pw.Row(children: [
  //                 // pw.Container(
  //                 //   height: 50.0,
  //                 //   width: 50.0,
  //                 //   alignment: pw.Alignment.centerRight,
  //                 //   margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 //   padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 //   decoration: pw.BoxDecoration(image: pw.DecorationImage(image: netImage), shape: pw.BoxShape.circle),
  //                 // ),
  //                 pw.SizedBox(width: 10.0),
  //                 pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //                   pw.Text(
  //                     personalInformation.companyName!,
  //                     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black, fontSize: 25.0, fontWeight: pw.FontWeight.bold),
  //                   ),
  //                   pw.Text(
  //                     'Tel: ${personalInformation.phoneNumber!}',
  //                     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.red),
  //                   ),
  //                 ]),
  //               ]),
  //               pw.SizedBox(height: 30.0),
  //               pw.Row(children: [
  //                 pw.Expanded(
  //                   child: pw.Container(
  //                     height: 40.0,
  //                     color: PdfColors.blueAccent,
  //                   ),
  //                 ),
  //                 pw.Padding(
  //                   padding: const pw.EdgeInsets.only(left: 10.0, right: 10.0),
  //                   child: pw.Text(
  //                     'Invoice/Bill',
  //                     style: pw.TextStyle(
  //                       color: PdfColors.black,
  //                       fontWeight: pw.FontWeight.bold,
  //                       fontSize: 25.0,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Container(
  //                   height: 40.0,
  //                   color: PdfColors.blueAccent,
  //                   width: 100,
  //                 ),
  //               ]),
  //               pw.SizedBox(height: 30.0),
  //               pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
  //                 pw.Column(children: [
  //                   pw.Row(children: [
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Bill To',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 10.0,
  //                       child: pw.Text(
  //                         ':',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         transactions.customerName,
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                   ]),
  //                   pw.Row(children: [
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Phone',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 10.0,
  //                       child: pw.Text(
  //                         ':',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         transactions.customerPhone,
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                   ]),
  //                 ]),
  //                 pw.Column(children: [
  //                   pw.Row(children: [
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Sells By',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 10.0,
  //                       child: pw.Text(
  //                         ':',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Admin',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                   ]),
  //                   pw.Row(children: [
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Invoice Number',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 10.0,
  //                       child: pw.Text(
  //                         ':',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         '#${transactions.invoiceNumber}',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                   ]),
  //                   pw.Row(children: [
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         'Date',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 10.0,
  //                       child: pw.Text(
  //                         ':',
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 100.0,
  //                       child: pw.Text(
  //                         DateTimeFormat.format(DateTime.parse(transactions.purchaseDate), format: 'D, M j'),
  //                         style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                       ),
  //                     ),
  //                   ]),
  //                 ]),
  //               ]),
  //             ],
  //           ),
  //         );
  //       },
  //       footer: (pw.Context context) {
  //         return pw.Column(children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10.0),
  //             child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
  //               pw.Container(
  //                 alignment: pw.Alignment.centerRight,
  //                 margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 child: pw.Column(children: [
  //                   pw.Container(
  //                     width: 120.0,
  //                     height: 2.0,
  //                     color: PdfColors.black,
  //                   ),
  //                   pw.SizedBox(height: 4.0),
  //                   pw.Text(
  //                     'Customer Signature',
  //                     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                   )
  //                 ]),
  //               ),
  //               pw.Container(
  //                 alignment: pw.Alignment.centerRight,
  //                 margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
  //                 child: pw.Column(children: [
  //                   pw.Container(
  //                     width: 120.0,
  //                     height: 2.0,
  //                     color: PdfColors.black,
  //                   ),
  //                   pw.SizedBox(height: 4.0),
  //                   pw.Text(
  //                     'Authorized Signature',
  //                     style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.black),
  //                   )
  //                 ]),
  //               ),
  //             ]),
  //           ),
  //           pw.Container(
  //             width: double.infinity,
  //             color: PdfColors.blueAccent,
  //             padding: const pw.EdgeInsets.all(10.0),
  //             child: pw.Center(child: pw.Text('Powered By Smart Biashara', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
  //           ),
  //         ]);
  //       },
  //       build: (pw.Context context) => <pw.Widget>[
  //         pw.Padding(
  //           padding: const pw.EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
  //           child: pw.Column(
  //             children: [
  //               pw.Table.fromTextArray(
  //                   context: context,
  //                   border: const pw.TableBorder(
  //                       left: pw.BorderSide(
  //                         color: PdfColors.blueAccent,
  //                       ),
  //                       right: pw.BorderSide(
  //                         color: PdfColors.blueAccent,
  //                       ),
  //                       bottom: pw.BorderSide(
  //                         color: PdfColors.blueAccent,
  //                       )),
  //                   headerDecoration: const pw.BoxDecoration(
  //                     color: PdfColors.blueAccent,
  //                   ),
  //                   columnWidths: <int, pw.TableColumnWidth>{
  //                     0: const pw.FlexColumnWidth(1),
  //                     1: const pw.FlexColumnWidth(6),
  //                     2: const pw.FlexColumnWidth(2),
  //                     3: const pw.FlexColumnWidth(2),
  //                     4: const pw.FlexColumnWidth(2),
  //                   },
  //                   headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
  //                   rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
  //                   oddRowDecoration: const pw.BoxDecoration(color: PdfColors.blue50),
  //                   headerAlignments: <int, pw.Alignment>{
  //                     0: pw.Alignment.center,
  //                     1: pw.Alignment.centerLeft,
  //                     2: pw.Alignment.center,
  //                     3: pw.Alignment.centerRight,
  //                     4: pw.Alignment.centerRight,
  //                   },
  //                   cellAlignments: <int, pw.Alignment>{
  //                     0: pw.Alignment.center,
  //                     1: pw.Alignment.centerLeft,
  //                     2: pw.Alignment.center,
  //                     3: pw.Alignment.centerRight,
  //                     4: pw.Alignment.centerRight,
  //                   },
  //                   data: <List<String>>[
  //                     <String>['SL', 'Item', 'Quantity', 'Unit Price', 'Total Price'],
  //                     for (int i = 0; i < transactions.productList!.length; i++)
  //                       <String>[
  //                         ('${i + 1}'),
  //                         (transactions.productList!.elementAt(i).productName.toString()),
  //                         (transactions.productList!.elementAt(i).quantity.toString()),
  //                         (myFormat.format(int.tryParse(transactions.productList!.elementAt(i).subTotal)??0)),
  //                         (myFormat.format(int.tryParse((int.parse(transactions.productList!.elementAt(i).subTotal) * transactions.productList!.elementAt(i).quantity.toInt()).toString())??0))
  //                       ],
  //                   ]),
  //               pw.Paragraph(text: ""),
  //               pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //                 children: [
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                     mainAxisAlignment: pw.MainAxisAlignment.end,
  //                     children: [
  //                       pw.SizedBox(height: 10.0),
  //                       pw.Text(
  //                         "Subtotal: ${myFormat.format(transactions.totalAmount! + transactions.discountAmount!)}",
  //                         style: pw.TextStyle(
  //                           color: PdfColors.black,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Text(
  //                         "Vat: 0.00",
  //                         style: pw.TextStyle(
  //                           color: PdfColors.black,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Text(
  //                         "Tax: 0.00",
  //                         style: pw.TextStyle(
  //                           color: PdfColors.black,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Text(
  //                         "Discount: ${myFormat.format(transactions.discountAmount)}",
  //                         style: pw.TextStyle(
  //                           color: PdfColors.black,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Container(
  //                         color: PdfColors.blueAccent,
  //                         padding: const pw.EdgeInsets.all(5.0),
  //                         child: pw.Text("Total Amount: ${myFormat.format(transactions.totalAmount)}", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Container(
  //                         width: 540,
  //                         child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
  //                           pw.Text(
  //                             "Paid Via: ${transactions.paymentType}",
  //                             style: const pw.TextStyle(
  //                               color: PdfColors.black,
  //                             ),
  //                           ),
  //                           pw.Text(
  //                             "Paid Amount: ${myFormat.format(transactions.totalAmount!.toDouble() - transactions.dueAmount!.toDouble())}",
  //                             style: pw.TextStyle(
  //                               color: PdfColors.black,
  //                               fontWeight: pw.FontWeight.bold,
  //                             ),
  //                           ),
  //                         ]),
  //                       ),
  //                       pw.SizedBox(height: 5.0),
  //                       pw.Text(
  //                         "Due: ${myFormat.format(transactions.dueAmount)}",
  //                         style: pw.TextStyle(
  //                           color: PdfColors.black,
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 10.0),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               pw.Padding(padding: const pw.EdgeInsets.all(10)),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (Platform.isIOS) {
  //     EasyLoading.show(status: 'Generating PDF');
  //     final dir = await getApplicationDocumentsDirectory();
  //     final file = File('${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');
  //     final byteData = await doc.save();
  //     try {
  //       await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //       EasyLoading.showSuccess('Done');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PDFViewerPage(path: '${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
  //         ),
  //       );
  //       // OpenFile.open("${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
  //     } on FileSystemException catch (err) {
  //       EasyLoading.showError(err.message);
  //       // handle error
  //     }
  //   }
  //   if (Platform.isAndroid) {
  //     var status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       status = await Permission.storage.request();
  //     }
  //     if (status.isGranted) {
  //       EasyLoading.show(status: 'Generating PDF');
  //       const downloadsFolderPath = '/storage/emulated/0/Download/';
  //       Directory dir = Directory(downloadsFolderPath);
  //       final file = File('${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf');
  //       final byteData = await doc.save();
  //       try {
  //         await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //         await Share.shareFiles(['${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'],text: 'Share PDF via...');
  //         EasyLoading.showSuccess('Created and Saved');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => PDFViewerPage(path: '${dir.path}/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf'),
  //           ),
  //         );
  //         // OpenFile.open("/storage/emulated/0/download/${'SalesPRO-${personalInformation.companyName}-${transactions.invoiceNumber}'}.pdf");
  //       } on FileSystemException catch (err) {
  //         EasyLoading.showError(err.message);
  //         // handle error
  //       }
  //     }
  //   }
  //   final output = await getTemporaryDirectory();
  //   final pdfFile = File('${output.path}/salesReport_${transactions.invoiceNumber}.pdf');
  //   await pdfFile.writeAsBytes(await pdf.save());
  //   // Share the PDF file via SharePlus
  //
  //   // await Share.shareXFiles([XFile.fromData(pdfFile.readAsBytesSync())], text: 'Share PDF via...');
  //   // Share.share(pdfFile.path,subject: 'Pdf Name');
  //   print(pdfFile);
  //   return pdfFile;
  // }

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() => subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() => isAlertSet = true);
      }
    },
  );

  checkInternet() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      showDialogBox();
      setState(() => isAlertSet = true);
    }
  }


  @override
  void initState() {
    getConnectivity();
    checkInternet();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await const Home().launch(context, isNewTask: true);
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).saleReports,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: kMainColor,
          elevation: 0.0,
        ),
        body: Consumer(builder: (context, ref, __) {
          final providerData = ref.watch(transitionProvider);
          final profile = ref.watch(profileDetailsProvider);
          final printerData = ref.watch(printerProviderNotifier);
          final personalData = ref.watch(profileDetailsProvider);
          return Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: fromDateTextEditingController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).formDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                    context: context,
                                  );
                                  setState(() {
                                    fromDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                    fromDate = picked!;
                                    totalSell = 0;
                                    count = 0;
                                    isPicked = true;
                                  });
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: toDateTextEditingController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).toDate,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    initialDate: toDate,
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                    context: context,
                                  );
                                  setState(() {
                                    toDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                    picked!.isToday ? toDate = DateTime.now() : toDate = picked;
                                    totalSell = 0;
                                    count = 0;
                                    isPicked = true;
                                  });
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  providerData.when(data: (transaction) {
                    final reTransaction = transaction.reversed.toList();
                    if (count == 0) {
                      count++;
                      for (var element in reTransaction) {
                        if (!isPicked) {
                          if (DateTime.parse(element.purchaseDate).month == DateTime.now().month && DateTime.parse(element.purchaseDate).year == DateTime.now().year) {
                            totalSell = totalSell + element.totalAmount!.toDouble();
                          }
                        } else {
                          if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) &&
                              (toDate.isAfter(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                            totalSell = totalSell + element.totalAmount!.toDouble();
                          }
                        }
                      }
                    }
                    return reTransaction.isNotEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20.0),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    color: kMainColor.withOpacity(0.08),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(80)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'images/ledger_total_sale.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        "$currency${myFormat.format(totalSell)}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(80)), color: kMainColor.withOpacity(0.2)),
                                          child: const Icon(
                                            Icons.picture_as_pdf_outlined,
                                            color: kMainColor,
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(80)),
                                            color: Colors.green.withOpacity(0.2),
                                          ),
                                          child: const Icon(
                                            Icons.print,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(80)), color: Colors.orange.withOpacity(0.2)),
                                          child: const Icon(
                                            Icons.notifications_none,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ]).visible(false),
                                      subtitle: Text('Total Sale ${isPicked ? '(From ${fromDate.toString().substring(0, 10)} to ${toDate.toString().substring(0, 10)})' : '(This Month)'}'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                                child: AppTextField(
                                  textFieldType: TextFieldType.NUMBER,
                                  onChanged: (value) {
                                    setState(() {
                                      invoiceNumber = value;
                                    });
                                  },
                                  decoration:  InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      labelText: lang.S.of(context).invoiceNumber,
                                      hintText: lang.S.of(context).enterInvoiceNumber,
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.search)),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reTransaction.length,
                                itemBuilder: (context, index) {
                                  return (fromDate.isBefore(DateTime.parse(reTransaction[index].purchaseDate)) || DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(fromDate)) &&
                                          (toDate.isAfter(DateTime.parse(reTransaction[index].purchaseDate)) || DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(toDate))
                                      ? GestureDetector(
                                          onTap: () {
                                            SalesInvoiceDetails(
                                              transitionModel: reTransaction[index],
                                              personalInformationModel: profile.value!,
                                            ).launch(context);
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(20),
                                                width: context.width(),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          reTransaction[index].customerName.isNotEmpty ? reTransaction[index].customerName : reTransaction[index].customerPhone,
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                        Text(
                                                          '#${reTransaction[index].invoiceNumber}',
                                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                              color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d).withOpacity(0.1) : const Color(0xFFED1A3B).withOpacity(0.1),
                                                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                          child: Text(
                                                            reTransaction[index].dueAmount! <= 0 ? 'Paid' : 'Unpaid',
                                                            style: TextStyle(color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                              style: const TextStyle(color: Colors.grey),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                              style: const TextStyle(color: Colors.grey),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Total : $currency ${myFormat.format(reTransaction[index].totalAmount)}',
                                                              style: const TextStyle(color: Colors.grey),
                                                            ),
                                                            const SizedBox(height: 3),
                                                            Text(
                                                              'Paid : $currency ${myFormat.format(reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble())}',
                                                              style: const TextStyle(color: Colors.grey),
                                                            ),
                                                            const SizedBox(height: 3),
                                                            Text(
                                                              'Due: $currency ${myFormat.format(reTransaction[index].dueAmount)}',
                                                              style: const TextStyle(fontSize: 16),
                                                            ).visible(reTransaction[index].dueAmount!.toInt() != 0),
                                                          ],
                                                        ),
                                                        personalData.when(data: (data) {
                                                          return Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () async {
                                                                    await printerData.getBluetooth();
                                                                    PrintTransactionModel model = PrintTransactionModel(transitionModel: reTransaction[index], personalInformationModel: data);
                                                                    connected
                                                                        ? printerData.printTicket(
                                                                            printTransactionModel: model,
                                                                            productList: model.transitionModel!.productList,
                                                                          )
                                                                        : showDialog(
                                                                            context: context,
                                                                            builder: (_) {
                                                                              return WillPopScope(
                                                                                onWillPop: () async => false,
                                                                                child: Dialog(
                                                                                  child: SizedBox(
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          itemCount:
                                                                                              printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                                                                                          itemBuilder: (context, index) {
                                                                                            return ListTile(
                                                                                              onTap: () async {
                                                                                                String select = printerData.availableBluetoothDevices[index];
                                                                                                List list = select.split("#");
                                                                                                // String name = list[0];
                                                                                                String mac = list[1];
                                                                                                bool isConnect = await printerData.setConnect(mac);
                                                                                                // ignore: use_build_context_synchronously
                                                                                                isConnect
                                                                                                    // ignore: use_build_context_synchronously
                                                                                                    ? finish(context)
                                                                                                    : toast('Try Again');
                                                                                              },
                                                                                              title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                              subtitle:  Text(lang.S.of(context).clickToConnect),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsets.only(top: 20, bottom: 10),
                                                                                          child: Text(
                                                                                            lang.S.of(context).pleaseConnectYourBluttothPrinter,
                                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(height: 10),
                                                                                        Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                        const SizedBox(height: 15),
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child:  Center(
                                                                                            child: Text(
                                                                                              lang.S.of(context).cacel,
                                                                                              style: TextStyle(color: kMainColor),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(height: 15),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                  },
                                                                  icon: const Icon(
                                                                    FeatherIcons.printer,
                                                                    color: Colors.grey,
                                                                  )),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    GeneratePdf().generateSaleDocument(reTransaction[index], data, context,share: false);
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.picture_as_pdf,
                                                                    color: Colors.grey,
                                                                  )),
                                                              IconButton(
                                                                  onPressed: ()  async {
                                                                    GeneratePdf().generateSaleDocument(reTransaction[index], data, context,share: true);
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.share,
                                                                    color: Colors.grey,
                                                                  )),
                                                            ],
                                                          );
                                                        }, error: (e, stack) {
                                                          return Text(e.toString());
                                                        }, loading: () {
                                                          return const Text('Loading');
                                                        }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 0.5,
                                                width: context.width(),
                                                color: Colors.grey,
                                              )
                                            ],
                                          ),
                                        ).visible(invoiceNumber.isEmptyOrNull ? true : reTransaction[index].invoiceNumber.toString().contains(invoiceNumber!))
                                      : Container();
                                },
                              ),
                            ],
                          )
                        : const Center(
                            child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: EmptyScreenWidget(),
                          ));
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(lang.S.of(context).noConnection),
      content: Text(lang.S.of(context).pleaseCheckYourInternetConnectivity),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: Text(lang.S.of(context).tryAgain),
        ),
      ],
    ),
  );
}
