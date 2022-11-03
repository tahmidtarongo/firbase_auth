import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/print_purchase_provider.dart';
import '../../Provider/printer_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../model/print_transaction_model.dart';
import '../../model/transition_model.dart';
import '../invoice_details/purchase_invoice_details.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

class LedgerCustomerDetailsScreen extends StatefulWidget {
  const LedgerCustomerDetailsScreen({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  @override
  State<LedgerCustomerDetailsScreen> createState() => _LedgerCustomerDetailsScreenState();
}

class _LedgerCustomerDetailsScreenState extends State<LedgerCustomerDetailsScreen> {
  double totalSale = 0;
  TextEditingController fromDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime(2021)));
  TextEditingController toDateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));

  DateTime fromDate = DateTime(2021);
  DateTime toDate = DateTime.now();

  Future<void> getTotalSale() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<TransitionModel> transitionList = [];
    await FirebaseDatabase.instance.ref(userId).child('Sales Transition').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(TransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    for (var element in transitionList) {
      if (element.customerPhone == widget.customerModel.phoneNumber) {
        totalSale = totalSale + element.totalAmount!.toInt();
      }
    }
  }

  Future<void> getTotalPurchase() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> transitionList = [];
    await FirebaseDatabase.instance.ref(userId).child('Purchase Transition').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(PurchaseTransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });

    for (var element in transitionList) {
      if (element.customerPhone == widget.customerModel.phoneNumber) {
        totalSale = totalSale + element.totalAmount!.toInt();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalSale();
    getTotalPurchase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(transitionProvider);
      final purchaseProviderData = ref.watch(purchaseTransitionProvider);
      final personalData = ref.watch(profileDetailsProvider);
      final printerData = ref.watch(printerProviderNotifier);
      final purchasePrinterData = ref.watch(printerPurchaseProviderNotifier);
      return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            title: Text(
              widget.customerModel.customerName,
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
          body: widget.customerModel.type != 'Supplier'
              ? Container(
                  alignment: Alignment.topCenter,
                  decoration:
                      const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                  child: providerData.when(data: (transaction) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                                    "$currency${totalSale.toInt().toString()}",
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
                                  ]),
                                  subtitle: const Text('Total Sale'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    controller: fromDateTextEditingController,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: 'From Date',
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
                                      labelText: 'To Date',
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
                                            toDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                            toDate = picked!;
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transaction.length,
                            itemBuilder: (context, index) {
                              final reTransaction = transaction.reversed.toList();

                              return reTransaction[index].customerPhone == widget.customerModel.phoneNumber &&
                                      fromDate.isBefore(DateTime.parse(reTransaction[index].purchaseDate)) &&
                                      (toDate.isAfter(DateTime.parse(reTransaction[index].purchaseDate)) ||
                                          DateTime.parse(reTransaction[index].purchaseDate).isToday)
                                  ? GestureDetector(
                                      onTap: () {
                                        SalesInvoiceDetails(
                                          personalInformationModel: personalData.value!,
                                          transitionModel: reTransaction[index],
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
                                                      "Total Products : ${reTransaction[index].productList!.length.toString()}",
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
                                                          color: reTransaction[index].dueAmount! <= 0
                                                              ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                              : const Color(0xFFED1A3B).withOpacity(0.1),
                                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                      child: Text(
                                                        reTransaction[index].dueAmount! <= 0 ? 'Paid' : 'Unpaid',
                                                        style: TextStyle(
                                                            color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Total : $currency ${reTransaction[index].totalAmount.toString()}',
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Paid : $currency ${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}',
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                                personalData.when(data: (data) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Due: $currency ${reTransaction[index].dueAmount.toString()}',
                                                        style: const TextStyle(fontSize: 16),
                                                      ).visible(reTransaction[index].dueAmount!.toInt() != 0),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () async {
                                                                await printerData.getBluetooth();
                                                                PrintTransactionModel model = PrintTransactionModel(
                                                                    transitionModel: reTransaction[index], personalInformationModel: data);
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
                                                                                            // ignore: use_build_context_synchronously
                                                                                            isConnect
                                                                                                // ignore: use_build_context_synchronously
                                                                                                ? finish(context)
                                                                                                : toast('Try Again');
                                                                                          },
                                                                                          title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                                                          subtitle: const Text("Click to connect"),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                    const SizedBox(height: 10),
                                                                                    Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                    const SizedBox(height: 15),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const Center(
                                                                                        child: Text(
                                                                                          'Cancel',
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
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                FeatherIcons.share,
                                                                color: Colors.grey,
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }, error: (e, stack) {
                                                  return Text(e.toString());
                                                }, loading: () {
                                                  return const Text('Loading');
                                                }),
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
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: CircularProgressIndicator());
                  }),
                )
              : Container(
                  alignment: Alignment.topCenter,
                  decoration:
                      const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                  child: purchaseProviderData.when(data: (transaction) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
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
                                    "$currency${totalSale.toInt().toString()}",
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
                                  ]),
                                  subtitle: const Text('Total Sale'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    controller: fromDateTextEditingController,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: 'From Date',
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
                                      labelText: 'To Date',
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
                                            toDateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transaction.length,
                            itemBuilder: (context, index) {
                              final reTransaction = transaction.reversed.toList();

                              return reTransaction[index].customerPhone == widget.customerModel.phoneNumber &&
                                      fromDate.isBefore(DateTime.parse(reTransaction[index].purchaseDate)) &&
                                      (toDate.isAfter(DateTime.parse(reTransaction[index].purchaseDate)) ||
                                          DateTime.parse(reTransaction[index].purchaseDate).isToday)
                                  ? GestureDetector(
                                      onTap: () {
                                        PurchaseInvoiceDetails(
                                          personalInformationModel: personalData.value!,
                                          transitionModel: reTransaction[index],
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
                                                      "Total Products : ${reTransaction[index].productList!.length.toString()}",
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
                                                          color: reTransaction[index].dueAmount! <= 0
                                                              ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                              : const Color(0xFFED1A3B).withOpacity(0.1),
                                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                      child: Text(
                                                        reTransaction[index].dueAmount! <= 0 ? 'Paid' : 'Unpaid',
                                                        style: TextStyle(
                                                            color: reTransaction[index].dueAmount! <= 0 ? const Color(0xff0dbf7d) : const Color(0xFFED1A3B)),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          DateFormat.yMMMd().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                        const SizedBox(height: 3),
                                                        Text(
                                                          DateFormat.jm().format(DateTime.parse(reTransaction[index].purchaseDate)),
                                                          style: const TextStyle(color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Total : $currency ${reTransaction[index].totalAmount.toString()}',
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Paid : $currency ${reTransaction[index].totalAmount!.toDouble() - reTransaction[index].dueAmount!.toDouble()}',
                                                  style: const TextStyle(color: Colors.grey),
                                                ),
                                                personalData.when(data: (data) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Due: $currency ${reTransaction[index].dueAmount.toString()}',
                                                        style: const TextStyle(fontSize: 16),
                                                      ).visible(reTransaction[index].dueAmount!.toInt() != 0),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () async {
                                                                ///________Print_______________________________________________________
                                                                await purchasePrinterData.getBluetooth();
                                                                PrintPurchaseTransactionModel model = PrintPurchaseTransactionModel(
                                                                    purchaseTransitionModel: reTransaction[index], personalInformationModel: data);
                                                                if (connected) {
                                                                  await purchasePrinterData.printTicket(
                                                                    printTransactionModel: model,
                                                                    productList: model.purchaseTransitionModel!.productList,
                                                                  );
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
                                                                                    itemCount: purchasePrinterData.availableBluetoothDevices.isNotEmpty
                                                                                        ? purchasePrinterData.availableBluetoothDevices.length
                                                                                        : 0,
                                                                                    itemBuilder: (context, index) {
                                                                                      return ListTile(
                                                                                        onTap: () async {
                                                                                          String select = purchasePrinterData.availableBluetoothDevices[index];
                                                                                          List list = select.split("#");
                                                                                          // String name = list[0];
                                                                                          String mac = list[1];
                                                                                          bool isConnect = await purchasePrinterData.setConnect(mac);
                                                                                          isConnect
                                                                                              // ignore: use_build_context_synchronously
                                                                                              ? finish(context)
                                                                                              : toast('Try Again');
                                                                                        },
                                                                                        title: Text('${purchasePrinterData.availableBluetoothDevices[index]}'),
                                                                                        subtitle: const Text("Click to connect"),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 10),
                                                                                  Container(height: 1, width: double.infinity, color: Colors.grey),
                                                                                  const SizedBox(height: 15),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Center(
                                                                                      child: Text(
                                                                                        'Cancel',
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
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                FeatherIcons.share,
                                                                color: Colors.grey,
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }, error: (e, stack) {
                                                  return Text(e.toString());
                                                }, loading: () {
                                                  return const Text('Loading');
                                                }),
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
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: CircularProgressIndicator());
                  }),
                ));
    });
  }
}
