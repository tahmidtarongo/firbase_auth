import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';

class LedgerCustomerDetailsScreen extends StatefulWidget {
  const LedgerCustomerDetailsScreen({Key? key, required this.customerModel}) : super(key: key);

  final CustomerModel customerModel;

  @override
  State<LedgerCustomerDetailsScreen> createState() => _LedgerCustomerDetailsScreenState();
}

class _LedgerCustomerDetailsScreenState extends State<LedgerCustomerDetailsScreen> {
  double totalSale = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(transitionProvider);
      final purchaseProviderData = ref.watch(purchaseTransitionProvider);
      final personalData = ref.watch(profileDetailsProvider);
      return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.customerModel.customerName,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: widget.customerModel.type != 'Supplier'
              ? providerData.when(data: (transaction) {
                  for (var element in transaction) {
                    if (element.customerPhone == widget.customerModel.phoneNumber) {
                      totalSale = totalSale + element.totalAmount!.toInt();
                    }
                  }
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
                                  "\$${totalSale.toInt().toString()}",
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
                                ]),
                                subtitle: const Text('Total Sale'),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transaction.length,
                          itemBuilder: (context, index) {
                            final reTransaction = transaction.reversed.toList();

                            return reTransaction[index].customerPhone == widget.customerModel.phoneNumber
                                ? GestureDetector(
                                    onTap: () {
                                      // SalesInvoiceDetails(
                                      //   personalInformationModel: widget.customerModel,
                                      //   transitionModel: reTransaction[index],
                                      // ).launch(context);
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
                                                  Text(
                                                    reTransaction[index].purchaseDate.substring(0, 10),
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Total : \$ ${reTransaction[index].totalAmount.toString()}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              personalData.when(data: (data) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Due: \$ ${reTransaction[index].dueAmount.toString()}',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    Row(
                                                      children: [
                                                        // IconButton(
                                                        //     onPressed: () async {
                                                        //       await printerData.getBluetooth();
                                                        //       PrintTransactionModel model = PrintTransactionModel(
                                                        //           transitionModel: reTransaction[index],
                                                        //           personalInformationModel: data);
                                                        //       connected
                                                        //           ? printerData.printTicket(
                                                        //         printTransactionModel: model,
                                                        //         productList: model.transitionModel!.productList,
                                                        //       )
                                                        //           : showDialog(
                                                        //           context: context,
                                                        //           builder: (_) {
                                                        //             return Dialog(
                                                        //               child: SizedBox(
                                                        //                 height: 200,
                                                        //                 child: ListView.builder(
                                                        //                   itemCount: printerData
                                                        //                       .availableBluetoothDevices
                                                        //                       .isNotEmpty
                                                        //                       ? printerData
                                                        //                       .availableBluetoothDevices.length
                                                        //                       : 0,
                                                        //                   itemBuilder: (context, index) {
                                                        //                     return ListTile(
                                                        //                       onTap: () async {
                                                        //                         String select = printerData
                                                        //                             .availableBluetoothDevices[index];
                                                        //                         List list = select.split("#");
                                                        //                         // String name = list[0];
                                                        //                         String mac = list[1];
                                                        //                         bool isConnect =
                                                        //                         await printerData.setConnect(mac);
                                                        //                         // ignore: use_build_context_synchronously
                                                        //                         isConnect
                                                        //                         // ignore: use_build_context_synchronously
                                                        //                             ? finish(context)
                                                        //                             : toast('Try Again');
                                                        //                       },
                                                        //                       title: Text(
                                                        //                           '${printerData.availableBluetoothDevices[index]}'),
                                                        //                       subtitle:
                                                        //                       const Text("Click to connect"),
                                                        //                     );
                                                        //                   },
                                                        //                 ),
                                                        //               ),
                                                        //             );
                                                        //           });
                                                        //     },
                                                        //     icon: const Icon(
                                                        //       FeatherIcons.printer,
                                                        //       color: Colors.grey,
                                                        //     )),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              FeatherIcons.share,
                                                              color: Colors.grey,
                                                            )),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              FeatherIcons.moreVertical,
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
                })
              : purchaseProviderData.when(data: (transaction) {
                  for (var element in transaction) {
                    if (element.customerPhone == widget.customerModel.phoneNumber) {
                      totalSale = totalSale + element.totalAmount!.toInt();
                    }
                  }
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
                                  "\$${totalSale.toInt().toString()}",
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
                                ]),
                                subtitle: const Text('Total Sale'),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transaction.length,
                          itemBuilder: (context, index) {
                            final reTransaction = transaction.reversed.toList();

                            return reTransaction[index].customerPhone == widget.customerModel.phoneNumber
                                ? GestureDetector(
                                    onTap: () {
                                      // SalesInvoiceDetails(
                                      //   personalInformationModel: widget.customerModel,
                                      //   transitionModel: reTransaction[index],
                                      // ).launch(context);
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
                                                  Text(
                                                    reTransaction[index].purchaseDate.substring(0, 10),
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Total : \$ ${reTransaction[index].totalAmount.toString()}',
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              personalData.when(data: (data) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Due: \$ ${reTransaction[index].dueAmount.toString()}',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    Row(
                                                      children: [
                                                        // IconButton(
                                                        //     onPressed: () async {
                                                        //       await printerData.getBluetooth();
                                                        //       PrintTransactionModel model = PrintTransactionModel(
                                                        //           transitionModel: reTransaction[index],
                                                        //           personalInformationModel: data);
                                                        //       connected
                                                        //           ? printerData.printTicket(
                                                        //         printTransactionModel: model,
                                                        //         productList: model.transitionModel!.productList,
                                                        //       )
                                                        //           : showDialog(
                                                        //           context: context,
                                                        //           builder: (_) {
                                                        //             return Dialog(
                                                        //               child: SizedBox(
                                                        //                 height: 200,
                                                        //                 child: ListView.builder(
                                                        //                   itemCount: printerData
                                                        //                       .availableBluetoothDevices
                                                        //                       .isNotEmpty
                                                        //                       ? printerData
                                                        //                       .availableBluetoothDevices.length
                                                        //                       : 0,
                                                        //                   itemBuilder: (context, index) {
                                                        //                     return ListTile(
                                                        //                       onTap: () async {
                                                        //                         String select = printerData
                                                        //                             .availableBluetoothDevices[index];
                                                        //                         List list = select.split("#");
                                                        //                         // String name = list[0];
                                                        //                         String mac = list[1];
                                                        //                         bool isConnect =
                                                        //                         await printerData.setConnect(mac);
                                                        //                         // ignore: use_build_context_synchronously
                                                        //                         isConnect
                                                        //                         // ignore: use_build_context_synchronously
                                                        //                             ? finish(context)
                                                        //                             : toast('Try Again');
                                                        //                       },
                                                        //                       title: Text(
                                                        //                           '${printerData.availableBluetoothDevices[index]}'),
                                                        //                       subtitle:
                                                        //                       const Text("Click to connect"),
                                                        //                     );
                                                        //                   },
                                                        //                 ),
                                                        //               ),
                                                        //             );
                                                        //           });
                                                        //     },
                                                        //     icon: const Icon(
                                                        //       FeatherIcons.printer,
                                                        //       color: Colors.grey,
                                                        //     )),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              FeatherIcons.share,
                                                              color: Colors.grey,
                                                            )),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              FeatherIcons.moreVertical,
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
                }));
    });
  }
}
