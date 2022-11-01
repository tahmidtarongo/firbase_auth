import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/due_transaction_provider.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/model/print_transaction_model.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/printer_due_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../constant.dart';
import '../../model/due_transaction_model.dart';
import '../Customers/Model/customer_model.dart';

class DueCollectionScreen extends StatefulWidget {
  const DueCollectionScreen({Key? key, required this.customerModel}) : super(key: key);

  @override
  State<DueCollectionScreen> createState() => _DueCollectionScreenState();
  final CustomerModel customerModel;
}

class _DueCollectionScreenState extends State<DueCollectionScreen> {
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double remainDueAmount = 0;
  double subTotal = 0;
  double dueAmount = 0;

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  // double calculateReturnAmount({required double total}) {
  //   returnAmount = total - paidAmount;
  //   return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  // }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      remainDueAmount = 0;
    } else {
      remainDueAmount = dueAmount - total;
    }
    return dueAmount - total;
  }

  TextEditingController controller = TextEditingController();
  TextEditingController paidText = TextEditingController();
  TextEditingController dateController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  late DueTransactionModel dueTransactionModel = DueTransactionModel(
    customerName: widget.customerModel.customerName,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  String? dropdownValue = 'Select an invoice';
  String? dropdownPaymentValue = 'Cash';
  String? selectedInvoice;

  // List of items in our dropdown menu
  List<String> items = ['Select an invoice'];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    return Consumer(builder: (context, consumerRef, __) {
      final customerProviderRef =
          widget.customerModel.type == 'Supplier' ? consumerRef.watch(purchaseTransitionProvider) : consumerRef.watch(transitionProvider);
      final printerData = consumerRef.watch(printerDueProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      return personalData.when(data: (data) {
        invoice = data.invoiceCounter!.toInt();
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text(
              'Collect Due',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0.0,
          ),
          body: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        customerProviderRef.when(data: (customer) {
                          for (var element in customer) {
                            if (element.customerPhone == widget.customerModel.phoneNumber && element.dueAmount != 0 && count < 2) {
                              items.add(element.invoiceNumber);
                            }
                            if (selectedInvoice == element.invoiceNumber) {
                              dueAmount = element.dueAmount!.toDouble();
                            }
                          }

                          return Container(
                            height: 60,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(05),
                              ),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Center(
                              child: DropdownButton(
                                value: dropdownValue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    paidAmount = 0;
                                    paidText.clear();
                                    dropdownValue = newValue.toString();
                                    controller.text = newValue.toString();
                                    selectedInvoice = newValue.toString();
                                  });
                                },
                              ),
                            ),
                          );
                        }, error: (e, stack) {
                          return Text(e.toString());
                        }, loading: () {
                          return const Center(child: CircularProgressIndicator());
                        }),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Date',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                    context: context,
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      dateController.text = DateFormat.yMMMd().format(picked);
                                      dueTransactionModel.purchaseDate = picked.toString();
                                    });
                                  }
                                },
                                icon: const Icon(FeatherIcons.calendar),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Due Amount: '),
                            Text(
                              widget.customerModel.dueAmount == '' ? '\$ 0' : '\$${widget.customerModel.dueAmount}',
                              style: const TextStyle(color: Color(0xFFFF8C34)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          initialValue: widget.customerModel.customerName,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ///_____Total______________________________
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xffEAEFFA), borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  dueAmount.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Paid Amount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width: context.width() / 4,
                                  child: TextField(
                                    controller: paidText,
                                    onChanged: (value) {
                                      if (value == '') {
                                        setState(() {
                                          paidAmount = 0;
                                        });
                                      } else {
                                        if (value.toDouble() <= dueAmount) {
                                          setState(() {
                                            paidAmount = double.parse(value);
                                          });
                                        } else {
                                          paidText.clear();
                                          setState(() {
                                            paidAmount = 0;
                                          });
                                          EasyLoading.showError('You can\'t pay more then due');
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(
                                      hintText: '0',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Due Amount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  calculateDueAmount(total: paidAmount).toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Payment Type',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.wallet,
                              color: Colors.green,
                            )
                          ],
                        ),
                        DropdownButton(
                          value: dropdownPaymentValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: paymentsTypeList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownPaymentValue = newValue.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Description',
                              hintText: 'Add Note',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.grey.shade200),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    FeatherIcons.camera,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Image',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ).visible(false),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (paidAmount >= 0) {
                                try {
                                  EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                                  final userId = FirebaseAuth.instance.currentUser!.uid;
                                  DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Due Transaction");

                                  dueTransactionModel.totalDue = dueAmount;
                                  remainDueAmount <= 0 ? dueTransactionModel.isPaid = true : dueTransactionModel.isPaid = false;
                                  remainDueAmount <= 0 ? dueTransactionModel.dueAmountAfterPay = 0 : dueTransactionModel.dueAmountAfterPay = remainDueAmount;
                                  dueTransactionModel.payDueAmount = paidAmount;
                                  dueTransactionModel.paymentType = dropdownPaymentValue;
                                  dueTransactionModel.invoiceNumber = invoice.toString();
                                  await ref.push().set(dueTransactionModel.toJson());

                                  ///_____UpdateInvoice__________________________________________________
                                  updateInvoice(
                                    type: widget.customerModel.type,
                                    invoice: selectedInvoice.toString(),
                                    remainDueAmount: remainDueAmount.toInt(),
                                  );

                                  final DatabaseReference personalInformationRef =
                                      // ignore: deprecated_member_use
                                      FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');

                                  await personalInformationRef.update({'invoiceCounter': invoice + 1});

                                  ///_________DueUpdate______________________________________________________
                                  getSpecificCustomers(
                                    phoneNumber: widget.customerModel.phoneNumber,
                                    due: paidAmount.toInt(),
                                  );

                                  ///________Subscription_____________________________________________________
                                  decreaseSubscriptionSale();

                                  ///________Print_______________________________________________________
                                  if (isPrintEnable) {
                                    await printerData.getBluetooth();
                                    PrintDueTransactionModel model =
                                        PrintDueTransactionModel(dueTransactionModel: dueTransactionModel, personalInformationModel: data);
                                    if (connected) {
                                      await printerData.printTicket(printDueTransactionModel: model);
                                      consumerRef.refresh(customerProvider);
                                      consumerRef.refresh(dueTransactionProvider);
                                      consumerRef.refresh(purchaseTransitionProvider);
                                      consumerRef.refresh(transitionProvider);
                                      consumerRef.refresh(profileDetailsProvider);

                                      EasyLoading.showSuccess('Added Successfully');
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        const DueReportScreen().launch(context);
                                      });
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Please Connect The Printer First"),
                                      ));
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
                                                              if (isConnect) {
                                                                await printerData.printTicket(printDueTransactionModel: model);
                                                                consumerRef.refresh(customerProvider);
                                                                consumerRef.refresh(dueTransactionProvider);
                                                                consumerRef.refresh(purchaseTransitionProvider);
                                                                consumerRef.refresh(transitionProvider);
                                                                consumerRef.refresh(profileDetailsProvider);
                                                                EasyLoading.showSuccess('Added Successfully');
                                                                Future.delayed(const Duration(milliseconds: 500), () {
                                                                  const DueReportScreen().launch(context);
                                                                });
                                                              }
                                                            },
                                                            title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                            subtitle: const Text("Click to connect"),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Container(
                                                        height: 1,
                                                        width: double.infinity,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(height: 15),
                                                      GestureDetector(
                                                        onTap: () {
                                                          consumerRef.refresh(customerProvider);
                                                          consumerRef.refresh(dueTransactionProvider);
                                                          consumerRef.refresh(purchaseTransitionProvider);
                                                          consumerRef.refresh(transitionProvider);
                                                          consumerRef.refresh(profileDetailsProvider);
                                                          const DueReportScreen().launch(context);
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
                                      EasyLoading.showSuccess('Added Successfully');
                                    }
                                  } else {
                                    consumerRef.refresh(customerProvider);
                                    consumerRef.refresh(dueTransactionProvider);
                                    consumerRef.refresh(purchaseTransitionProvider);
                                    consumerRef.refresh(transitionProvider);
                                    consumerRef.refresh(profileDetailsProvider);

                                    EasyLoading.showSuccess('Added Successfully');
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      const DueReportScreen().launch(context);
                                    });
                                  }
                                } catch (e) {
                                  EasyLoading.dismiss();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              } else {
                                EasyLoading.showError('Add product first');
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                color: kMainColor,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Center(
          child: Text(e.toString()),
        );
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      });
    });
  }

  void updateInvoice({required String type, required String invoice, required int remainDueAmount}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = type == 'Supplier' ? FirebaseDatabase.instance.ref('$userId/Purchase Transition/') : FirebaseDatabase.instance.ref('$userId/Sales Transition/');
    String? key;

    type == 'Supplier'
        ? await FirebaseDatabase.instance.ref(userId).child('Purchase Transition/').orderByKey().get().then((value) {
            for (var element in value.children) {
              var data = jsonDecode(jsonEncode(element.value));
              if (data['invoiceNumber'] == invoice) {
                key = element.key;
              }
            }
          })
        : await FirebaseDatabase.instance.ref(userId).child('Sales Transition').orderByKey().get().then((value) {
            for (var element in value.children) {
              var data = jsonDecode(jsonEncode(element.value));
              if (data['invoiceNumber'] == invoice) {
                key = element.key;
              }
            }
          });
    ref.child(key!).update({
      'dueAmount': '$remainDueAmount',
    });
  }

  void getSpecificCustomers({required String phoneNumber, required int due}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Customers/');
    String? key;

    await FirebaseDatabase.instance.ref(userId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
        }
      }
    });
    var data1 = await ref.child('$key/due').once();
    int previousDue = data1.snapshot.value.toString().toInt();

    int totalDue = previousDue - due;
    ref.child(key!).update({'due': '$totalDue'});
  }

  void decreaseSubscriptionSale() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Subscription/dueNumber');
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    FirebaseDatabase.instance.ref('$userId/Subscription').update({'dueNumber': afterSale});
  }
}
