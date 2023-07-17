import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../../Provider/due_transaction_provider.dart';
import '../../../Provider/printer_due_provider.dart';
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../../currency.dart';
import '../../../empty_screen_widget.dart';
import '../../../model/print_transaction_model.dart';
import '../../Home/home.dart';
import '../../invoice_details/due_invoice_details.dart';

class DueReportScreen extends StatefulWidget {
  const DueReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DueReportScreenState createState() => _DueReportScreenState();
}

class _DueReportScreenState extends State<DueReportScreen> {
  String? invoiceNumber;
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();
  double totalDue = 0;
  bool isPicked = false;
  int count = 0;

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
            lang.S.of(context).dueReports,
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
          final providerData = ref.watch(dueTransactionProvider);
          final printerData = ref.watch(printerDueProviderNotifier);
          final personalData = ref.watch(profileDetailsProvider);
          final profile = ref.watch(profileDetailsProvider);
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
                                    totalDue = 0;
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
                                    totalDue = 0;
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
                    if(count == 0){
                      count++;
                      for (var element in reTransaction) {
                        if(!isPicked){
                          if (DateTime.parse(element.purchaseDate).month == DateTime.now().month && DateTime.parse(element.purchaseDate).year == DateTime.now().year) {
                            totalDue = totalDue + element.totalDue!.toDouble();
                          }
                        } else{
                          if ((fromDate.isBefore(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(fromDate)) &&
                              (toDate.isAfter(DateTime.parse(element.purchaseDate)) || DateTime.parse(element.purchaseDate).isAtSameMomentAs(toDate))) {
                            totalDue = totalDue + element.totalDue!.toDouble();
                          }
                        }
                      }
                    }
                    return transaction.isNotEmpty
                        ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20.0),
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
                                      "$currency${totalDue.toString()}",
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
                                        decoration:
                                        BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(80)), color: Colors.orange.withOpacity(0.2)),
                                        child: const Icon(
                                          Icons.notifications_none,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ]).visible(false),
                                    subtitle: Text('Total Due ${isPicked ? '(From ${fromDate.toString().substring(0,10)} to ${toDate.toString().substring(0,10)})' : '(This Month)'}'),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
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
                                  prefixIcon: Icon(Icons.search)
                                ),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transaction.length,
                                itemBuilder: (context, index) {
                                  return (fromDate.isBefore(DateTime.parse(reTransaction[index].purchaseDate)) ||
                                      DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(fromDate)) &&
                                      (toDate.isAfter(DateTime.parse(reTransaction[index].purchaseDate)) ||
                                          DateTime.parse(reTransaction[index].purchaseDate).isAtSameMomentAs(toDate))
                                      ? GestureDetector(
                                    onTap: () {
                                      DueInvoiceDetails(
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
                                                    reTransaction[index].customerName.isNotEmpty
                                                        ? reTransaction[index].customerName
                                                        : reTransaction[index].customerPhone,
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  Text('#${reTransaction[index].invoiceNumber}'),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: reTransaction[index].dueAmountAfterPay! <= 0
                                                            ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                            : const Color(0xFFED1A3B).withOpacity(0.1),
                                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                    child: Text(
                                                      reTransaction[index].dueAmountAfterPay! <= 0 ? 'Fully Paid' : 'Still Unpaid',
                                                      style: TextStyle(
                                                          color: reTransaction[index].dueAmountAfterPay! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
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
                                                        'Total : $currency ${reTransaction[index].totalDue.toString()}',
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        'Paid : $currency ${reTransaction[index].totalDue!.toDouble() - reTransaction[index].dueAmountAfterPay!.toDouble()}',
                                                        style: const TextStyle(color: Colors.grey),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        'Due: $currency ${reTransaction[index].dueAmountAfterPay.toString()}',
                                                        style: const TextStyle(fontSize: 16),
                                                      ).visible(reTransaction[index].dueAmountAfterPay!.toInt() != 0),
                                                    ],
                                                  ),
                                                  personalData.when(data: (data) {
                                                    return Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () async {
                                                              ///________Print_______________________________________________________
                                                              await printerData.getBluetooth();
                                                              PrintDueTransactionModel model =
                                                                  PrintDueTransactionModel(dueTransactionModel: reTransaction[index], personalInformationModel: data);
                                                              if (connected) {
                                                                await printerData.printTicket(printDueTransactionModel: model);
                                                              } else {
                                                                showDialog(
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
                                                                                  itemCount: printerData.availableBluetoothDevices.isNotEmpty
                                                                                      ? printerData.availableBluetoothDevices.length
                                                                                      : 0,
                                                                                  itemBuilder: (context, index) {
                                                                                    return ListTile(
                                                                                      onTap: () async {
                                                                                        String select = printerData.availableBluetoothDevices[index];
                                                                                        List list = select.split("#");
                                                                                        // String name = list[0];
                                                                                        String mac = list[1];
                                                                                        bool isConnect = await printerData.setConnect(mac);
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
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              FeatherIcons.printer,
                                                              color: Colors.grey,
                                                            )),
                                                        IconButton(
                                                            onPressed: () => toast('Coming Soon'),
                                                            icon: const Icon(
                                                              FeatherIcons.share,
                                                              color: Colors.grey,
                                                            )).visible(false),
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
                                  ).visible(invoiceNumber.isEmptyOrNull ? true : reTransaction[index].invoiceNumber.toString().contains(invoiceNumber!)) : Container();
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
                      padding: EdgeInsets.all(20.0),
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
}
