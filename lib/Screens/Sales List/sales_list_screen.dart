import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/printer_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Sales%20List/sales_report_edit_screen.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../../Provider/profile_provider.dart';
import '../../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../Home/home.dart';
import '../invoice_details/sales_invoice_details_screen.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {

  String? invoiceNumber;

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
            lang.S.of(context).salesList,
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
          final cart = ref.watch(cartNotifier);
          return Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          prefixIcon: const Icon(Icons.search)
                      ),
                    ),
                  ),
                  providerData.when(data: (transaction) {
                    final reTransaction = transaction.reversed.toList();
                    return reTransaction.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reTransaction.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
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
                                                reTransaction[index].customerName.isNotEmpty
                                                    ? reTransaction[index].customerName
                                                    : reTransaction[index].customerPhone,
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
                                                    color: reTransaction[index].dueAmount! <= 0
                                                        ? const Color(0xff0dbf7d).withOpacity(0.1)
                                                        : const Color(0xFFED1A3B).withOpacity(0.1),
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
                                                          PrintTransactionModel model =
                                                              PrintTransactionModel(transitionModel: reTransaction[index], personalInformationModel: data);
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
                                                        onPressed: () => toast('Coming Soon'),
                                                        icon: const Icon(
                                                          FeatherIcons.share,
                                                          color: Colors.grey,
                                                        )).visible(false),
                                                    IconButton(
                                                        onPressed: () {
                                                          cart.clearCart();
                                                          SalesReportEditScreen(
                                                            transitionModel: reTransaction[index],
                                                          ).launch(context);
                                                        },
                                                        icon: const Icon(
                                                          FeatherIcons.edit,
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
                              ).visible(invoiceNumber.isEmptyOrNull ? true : reTransaction[index].invoiceNumber.toString().contains(invoiceNumber!));
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: EmptyScreenWidget(),
                          );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: CircularProgressIndicator());
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
