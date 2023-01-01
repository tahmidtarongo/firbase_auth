import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Provider/transactions_provider.dart';
import 'package:mobile_pos/Screens/Sales/sales_screen.dart';
import 'package:mobile_pos/Screens/invoice_details/sales_invoice_details_screen.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:mobile_pos/subscription.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/printer_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/seles_report_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/print_transaction_model.dart';
import '../Customers/Model/customer_model.dart';
import '../Home/home.dart';

// ignore: must_be_immutable
class AddSalesScreen extends StatefulWidget {
  AddSalesScreen({Key? key, required this.customerModel}) : super(key: key);

  CustomerModel customerModel;

  @override
  State<AddSalesScreen> createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  TextEditingController paidText = TextEditingController();
  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;

  String? dropdownValue = 'Cash';
  String? selectedPaymentType;
  TextEditingController dateTextEditingController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));

  double calculateSubtotal({required double total}) {
    subTotal = total - discountAmount;
    return total - discountAmount;
  }

  double calculateReturnAmount({required double total}) {
    returnAmount = total - paidAmount;
    return paidAmount <= 0 || paidAmount <= subTotal ? 0 : total - paidAmount;
  }

  double calculateDueAmount({required double total}) {
    if (total < 0) {
      dueAmount = 0;
    } else {
      dueAmount = subTotal - paidAmount;
    }
    return returnAmount <= 0 ? 0 : subTotal - paidAmount;
  }

  double percentage = 0;
  TextEditingController discountAmountEditingController = TextEditingController();
  TextEditingController discountPercentageEditingController = TextEditingController();


  late TransitionModel transitionModel = TransitionModel(
    customerName: widget.customerModel.customerName,
    customerPhone: widget.customerModel.phoneNumber,
    customerType: widget.customerModel.type,
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
    vat: 0,
    serviceCharge: 0,
  );
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final printerData = consumerRef.watch(printerProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      return personalData.when(data: (data) {
        invoice = data.saleInvoiceCounter!.toInt();
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: Text(
              'Add Sales',
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
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            initialValue: data.saleInvoiceCounter.toString(),
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Inv No.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            readOnly: true,
                            controller: dateTextEditingController,
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
                                  setState(() {
                                    dateTextEditingController.text = DateFormat.yMMMd().format(picked ?? DateTime.now());
                                    transitionModel.purchaseDate = picked.toString();
                                  });
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
                              widget.customerModel.dueAmount == '' ? '$currency 0' : '$currency${widget.customerModel.dueAmount}',
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
                          initialValue: widget.customerModel.customerName.isNotEmpty ? widget.customerModel.customerName : widget.customerModel.phoneNumber,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ///_______Added_ItemS__________________________________________________
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        border: Border.all(width: 1, color: const Color(0xffEAEFFA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xffEAEFFA),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  width: context.width() / 1.35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Item Added',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Quantity',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: providerData.cartItemList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(providerData.cartItemList[index].productName.toString()),
                                    subtitle: Text(
                                        '${providerData.cartItemList[index].quantity} X ${providerData.cartItemList[index].subTotal} = ${double.parse(providerData.cartItemList[index].subTotal) * providerData.cartItemList[index].quantity}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  providerData.quantityDecrease(index);
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: const BoxDecoration(
                                                    color: kMainColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${providerData.cartItemList[index].quantity}',
                                                style: GoogleFonts.poppins(
                                                  color: kGreyTextColor,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  providerData.quantityIncrease(index);
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: const BoxDecoration(
                                                    color: kMainColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    '+',
                                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            providerData.deleteToCart(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            color: Colors.red.withOpacity(0.1),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ).visible(providerData.cartItemList.isNotEmpty),
                    ),
                    const SizedBox(height: 20),

                    ///_______Add_Button__________________________________________________
                    GestureDetector(
                      onTap: () {
                        SaleProducts(
                          catName: null,
                          customerModel: widget.customerModel,
                        ).launch(context);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(color: kMainColor.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                            child: Text(
                          'Add Items',
                          style: TextStyle(color: kMainColor, fontSize: 20),
                        )),
                      ),
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
                                  'Sub Total',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  providerData.getTotalAmount().toString(),
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
                                  'Discount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: context.width() / 4,
                                      height: 40.0,
                                      child: Center(
                                        child: AppTextField(
                                          controller: discountPercentageEditingController,
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                percentage = 0.0;
                                              });
                                            } else {
                                              if (value.toInt() <=100 ) {
                                                setState(() {
                                                  discountAmount = (value.toDouble()/100) * providerData.getTotalAmount().toDouble();
                                                  discountAmountEditingController.text = discountAmount.toString();
                                                });
                                              } else {
                                                paidText.clear();
                                                setState(() {
                                                  discountAmount = 0;
                                                  discountAmountEditingController.text = discountAmount.toString();
                                                });
                                                EasyLoading.showError('Enter a valid Discount');
                                              }
                                            }
                                          },
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                            hintText: '0',
                                            border: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: Color(0xFFff5f00))),
                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: Color(0xFFff5f00))),
                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: Color(0xFFff5f00))),
                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: Color(0xFFff5f00))),
                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                            prefixIcon: Container(
                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFff5f00),
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                              child: const Text(
                                                '%',
                                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          textFieldType: TextFieldType.PHONE,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    SizedBox(
                                      width: context.width() / 4,
                                      height: 40.0,
                                      child: Center(
                                        child: AppTextField(
                                          controller: discountAmountEditingController,
                                          onChanged: (value) {
                                            if (value == '') {
                                              setState(() {
                                                discountAmount = 0;
                                              });
                                            } else {
                                              if (value.toInt() <= providerData.getTotalAmount()) {
                                                setState(() {
                                                  discountAmount = double.parse(value);
                                                  discountPercentageEditingController.text = ((discountAmount * 100) /providerData.getTotalAmount() ).toString();
                                                });
                                              } else {
                                                paidText.clear();
                                                setState(() {
                                                  discountAmount = 0;
                                                  discountPercentageEditingController.text = '0';
                                                });
                                                EasyLoading.showError('Enter a valid Discount');
                                              }
                                            }
                                          },
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(right: 6.0),
                                            hintText: '0',
                                            border: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: kMainColor)),
                                            enabledBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: kMainColor)),
                                            disabledBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: kMainColor)),
                                            focusedBorder: const OutlineInputBorder(gapPadding: 0.0,borderSide: BorderSide(color: kMainColor)),
                                            prefixIconConstraints: const BoxConstraints(maxWidth: 30.0, minWidth: 30.0),
                                            prefixIcon: Container(
                                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: kMainColor,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), bottomLeft: Radius.circular(4.0))),
                                              child: Text(
                                                currency,
                                                style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          textFieldType: TextFieldType.PHONE,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  'Total',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  calculateSubtotal(total: providerData.getTotalAmount()).toString(),
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
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value == '') {
                                        setState(() {
                                          paidAmount = 0;
                                        });
                                      } else {
                                        setState(() {
                                          paidAmount = double.parse(value);
                                        });
                                      }
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: const InputDecoration(hintText: '0'),
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
                                  'Return Amount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  calculateReturnAmount(total: subTotal).abs().toString(),
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
                                  'Due Amount',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  calculateDueAmount(total: subTotal).toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: paymentsTypeList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue.toString();
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
                    const SizedBox(height: 30),
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
                          ),
                        ),
                      ],
                    ).visible(false),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            // if (providerData.cartItemList.isNotEmpty) {
                            //   if (widget.customerModel.type == 'Guest' && dueAmount > 0) {
                            //     EasyLoading.showError('Due is not available for guest');
                            //   } else {
                            //     try {
                            //       EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            //
                            //       final userId = FirebaseAuth.instance.currentUser!.uid;
                            //       DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Sales Transition");
                            //       ref.keepSynced(true);
                            //
                            //       dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                            //       dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                            //       returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                            //       transitionModel.discountAmount = discountAmount;
                            //       transitionModel.totalAmount = subTotal;
                            //       transitionModel.productList = providerData.cartItemList;
                            //       transitionModel.paymentType = dropdownValue;
                            //       transitionModel.invoiceNumber = invoice.toString();
                            //
                            //       ///__________total LossProfit & quantity________________________________________________________________
                            //
                            //       int totalQuantity = 0;
                            //       double lossProfit = 0;
                            //       double totalPurchasePrice = 0;
                            //       double totalSalePrice = 0;
                            //       for (var element in transitionModel.productList!) {
                            //         totalPurchasePrice = totalPurchasePrice + (double.parse(element.productPurchasePrice) * element.quantity);
                            //         totalSalePrice = totalSalePrice + (double.parse(element.subTotal) * element.quantity);
                            //
                            //         totalQuantity = totalQuantity + element.quantity;
                            //       }
                            //       lossProfit = ((totalSalePrice - totalPurchasePrice.toDouble()) - double.parse(transitionModel.discountAmount.toString()));
                            //
                            //       transitionModel.totalQuantity = totalQuantity;
                            //       transitionModel.lossProfit = lossProfit;
                            //
                            //       await ref.push().set(transitionModel.toJson());
                            //
                            //       ///__________StockMange_________________________________________________-
                            //
                            //       for (var element in providerData.cartItemList) {
                            //         decreaseStock(element.productId, element.quantity);
                            //       }
                            //
                            //       ///_______invoice_Update_____________________________________________
                            //       final DatabaseReference personalInformationRef =
                            //           // ignore: deprecated_member_use
                            //           FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
                            //       personalInformationRef.keepSynced(true);
                            //       await personalInformationRef.update({'invoiceCounter': invoice + 1});
                            //
                            //       ///________Subscription_____________________________________________________
                            //       Subscription.decreaseSubscriptionLimits(itemType: 'saleNumber', context: context);
                            //
                            //       ///_________DueUpdate______________________________________________________
                            //       getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());
                            //       await printerData.getBluetooth();
                            //       PrintTransactionModel model = PrintTransactionModel(transitionModel: transitionModel, personalInformationModel: data);
                            //
                            //       ///_________printer________________________________________
                            //       if (isPrintEnable) {
                            //         if (connected) {
                            //           await printerData.printTicket(printTransactionModel: model, productList: providerData.cartItemList);
                            //           providerData.clearCart();
                            //           consumerRef.refresh(customerProvider);
                            //           consumerRef.refresh(productProvider);
                            //           consumerRef.refresh(salesReportProvider);
                            //           consumerRef.refresh(transitionProvider);
                            //           consumerRef.refresh(profileDetailsProvider);
                            //
                            //           EasyLoading.showSuccess('Added Successfully');
                            //           Future.delayed(const Duration(milliseconds: 500), () {
                            //             const Home().launch(context);
                            //           });
                            //         } else {
                            //           EasyLoading.showSuccess('Added Successfully');
                            //           // ignore: use_build_context_synchronously
                            //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            //             content: Text("Please Connect The Printer First"),
                            //           ));
                            //           // EasyLoading.showInfo('Please Connect The Printer First');
                            //           showDialog(
                            //               context: context,
                            //               builder: (_) {
                            //                 return WillPopScope(
                            //                   onWillPop: () async => false,
                            //                   child: Dialog(
                            //                     child: SizedBox(
                            //                       child: Column(
                            //                         mainAxisSize: MainAxisSize.min,
                            //                         children: [
                            //                           ListView.builder(
                            //                             shrinkWrap: true,
                            //                             itemCount:
                            //                                 printerData.availableBluetoothDevices.isNotEmpty ? printerData.availableBluetoothDevices.length : 0,
                            //                             itemBuilder: (context, index) {
                            //                               return ListTile(
                            //                                 onTap: () async {
                            //                                   String select = printerData.availableBluetoothDevices[index];
                            //                                   List list = select.split("#");
                            //                                   // String name = list[0];
                            //                                   String mac = list[1];
                            //                                   bool isConnect = await printerData.setConnect(mac);
                            //                                   if (isConnect) {
                            //                                     await printerData.printTicket(
                            //                                         printTransactionModel: model, productList: transitionModel.productList);
                            //                                     providerData.clearCart();
                            //                                     consumerRef.refresh(customerProvider);
                            //                                     consumerRef.refresh(productProvider);
                            //                                     consumerRef.refresh(salesReportProvider);
                            //                                     consumerRef.refresh(transitionProvider);
                            //                                     consumerRef.refresh(profileDetailsProvider);
                            //                                     EasyLoading.showSuccess('Added Successfully');
                            //                                     Future.delayed(const Duration(milliseconds: 500), () {
                            //                                       const Home().launch(context);
                            //                                     });
                            //                                   }
                            //                                 },
                            //                                 title: Text('${printerData.availableBluetoothDevices[index]}'),
                            //                                 subtitle: const Text("Click to connect"),
                            //                               );
                            //                             },
                            //                           ),
                            //                           const SizedBox(height: 10),
                            //                           Container(
                            //                             height: 1,
                            //                             width: double.infinity,
                            //                             color: Colors.grey,
                            //                           ),
                            //                           const SizedBox(height: 15),
                            //                           GestureDetector(
                            //                             onTap: () {
                            //                               consumerRef.refresh(customerProvider);
                            //                               consumerRef.refresh(productProvider);
                            //                               consumerRef.refresh(salesReportProvider);
                            //                               consumerRef.refresh(transitionProvider);
                            //                               consumerRef.refresh(profileDetailsProvider);
                            //                               const Home().launch(context);
                            //                             },
                            //                             child: const Center(
                            //                               child: Text(
                            //                                 'Cancel',
                            //                                 style: TextStyle(color: kMainColor),
                            //                               ),
                            //                             ),
                            //                           ),
                            //                           const SizedBox(height: 15),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 );
                            //               });
                            //         }
                            //       } else {
                            //         providerData.clearCart();
                            //         consumerRef.refresh(customerProvider);
                            //         consumerRef.refresh(productProvider);
                            //         consumerRef.refresh(salesReportProvider);
                            //         consumerRef.refresh(transitionProvider);
                            //         consumerRef.refresh(profileDetailsProvider);
                            //         EasyLoading.showSuccess('Added Successfully');
                            //         Future.delayed(const Duration(milliseconds: 500), () {
                            //           const SalesReportScreen().launch(context);
                            //         });
                            //       }
                            //       EasyLoading.showSuccess('Added Successfully');
                            //       // const Home().launch(context, isNewTask: true);
                            //     } catch (e) {
                            //       EasyLoading.dismiss();
                            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            //     }
                            //   }
                            // } else {
                            //   EasyLoading.showError('Add Product first');
                            // }
                            const Home().launch(context);
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (providerData.cartItemList.isNotEmpty) {
                                if (widget.customerModel.type == 'Guest' && dueAmount > 0) {
                                  EasyLoading.showError('Due is not available for guest');
                                } else {
                                  try {
                                    final userId = FirebaseAuth.instance.currentUser!.uid;
                                    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Sales Transition");
                                    ref.keepSynced(true);
                                    dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                                    dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                                    returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                                    transitionModel.discountAmount = discountAmount;
                                    transitionModel.totalAmount = subTotal;
                                    transitionModel.productList = providerData.cartItemList;
                                    transitionModel.paymentType = dropdownValue;
                                    transitionModel.invoiceNumber = invoice.toString();

                                    int totalQuantity = 0;
                                    double lossProfit = 0;
                                    double totalPurchasePrice = 0;
                                    double totalSalePrice = 0;
                                    for (var element in transitionModel.productList!) {
                                      totalPurchasePrice = totalPurchasePrice + (double.parse(element.productPurchasePrice) * element.quantity);
                                      totalSalePrice = totalSalePrice + (double.parse(element.subTotal) * element.quantity);

                                      totalQuantity = totalQuantity + element.quantity;
                                    }
                                    lossProfit = ((totalSalePrice - totalPurchasePrice.toDouble()) - double.parse(transitionModel.discountAmount.toString()));

                                    transitionModel.totalQuantity = totalQuantity;
                                    transitionModel.lossProfit = lossProfit;
                                    ref.push().set(transitionModel.toJson());

                                    ///__________StockMange_________________________________________________-

                                    for (var element in providerData.cartItemList) {
                                      decreaseStock(element.productId, element.quantity);
                                    }

                                    ///_______invoice_Update_____________________________________________
                                    final DatabaseReference personalInformationRef =
                                        // ignore: deprecated_member_use
                                        FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
                                    personalInformationRef.keepSynced(true);
                                    personalInformationRef.update({'saleInvoiceCounter': invoice + 1});


                                    ///________Subscription_____________________________________________________

                                    Subscription.decreaseSubscriptionLimits(itemType: 'saleNumber', context: context);


                                    ///_________DueUpdate______________________________________________________
                                    getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());

                                    ///________Print_______________________________________________________

                                    PrintTransactionModel model = PrintTransactionModel(transitionModel: transitionModel, personalInformationModel: data);
                                    if (isPrintEnable) {
                                      await printerData.getBluetooth();
                                      if (connected) {
                                        await printerData.printTicket(printTransactionModel: model, productList: providerData.cartItemList);

                                        consumerRef.refresh(customerProvider);
                                        consumerRef.refresh(productProvider);
                                        consumerRef.refresh(salesReportProvider);
                                        consumerRef.refresh(transitionProvider);
                                        consumerRef.refresh(profileDetailsProvider);

                                        EasyLoading.dismiss();
                                        await Future.delayed(const Duration(milliseconds: 500)).then((value) => SalesInvoiceDetails(transitionModel: transitionModel, personalInformationModel: data).launch(context));
                                      } else {
                                        EasyLoading.dismiss();
                                        // ignore: use_build_context_synchronously
                                        EasyLoading.showError('Please Connect The Printer First');

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
                                                                if (isConnect) {
                                                                  await printerData.printTicket(
                                                                      printTransactionModel: model, productList: transitionModel.productList);

                                                                  consumerRef.refresh(customerProvider);
                                                                  consumerRef.refresh(productProvider);
                                                                  consumerRef.refresh(salesReportProvider);
                                                                  consumerRef.refresh(transitionProvider);
                                                                  consumerRef.refresh(profileDetailsProvider);
                                                                  EasyLoading.dismiss();
                                                                  await Future.delayed(const Duration(milliseconds: 500)).then((value) => SalesInvoiceDetails(transitionModel: transitionModel, personalInformationModel: data).launch(context));
                                                                }
                                                              },
                                                              title: Text('${printerData.availableBluetoothDevices[index]}'),
                                                              subtitle: const Text("Click to connect"),
                                                            );
                                                          },
                                                        ).visible(printerData.availableBluetoothDevices.isNotEmpty),
                                                        const Padding(
                                                          padding: EdgeInsets.only(top: 20, bottom: 10),
                                                          child: Text(
                                                            'Please connect your bluetooth Printer',
                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Container(
                                                          height: 1,
                                                          width: double.infinity,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(height: 15),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            consumerRef.refresh(customerProvider);
                                                            consumerRef.refresh(productProvider);
                                                            consumerRef.refresh(salesReportProvider);
                                                            consumerRef.refresh(transitionProvider);
                                                            consumerRef.refresh(profileDetailsProvider);
                                                            await Future.delayed(const Duration(milliseconds: 500)).then((value) => SalesInvoiceDetails(transitionModel: transitionModel, personalInformationModel: data).launch(context));
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
                                    } else {
                                      consumerRef.refresh(customerProvider);
                                      consumerRef.refresh(productProvider);
                                      consumerRef.refresh(salesReportProvider);
                                      consumerRef.refresh(transitionProvider);
                                      consumerRef.refresh(profileDetailsProvider);
                                      EasyLoading.dismiss();
                                      await Future.delayed(const Duration(milliseconds: 500)).then((value) => SalesInvoiceDetails(transitionModel: transitionModel, personalInformationModel: data).launch(context));
                                    }
                                  } catch (e) {
                                    EasyLoading.showError(e.toString());
                                  }
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

  void decreaseStock(String productCode, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(userId).child('Products');
    ref.keepSynced(true);

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'] == productCode) {
          String? key = element.key;
          int previousStock = element.child('productStock').value.toString().toInt();
          print(previousStock);
          int remainStock = previousStock - quantity;
          ref.child(key!).update({'productStock': '$remainStock'});
        }
      }
    });

    // var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    // String productPath = data.snapshot.value.toString().substring(1, 21);
    //
    // var data1 = await ref.child('$productPath/productStock').once();
    // int stock = int.parse(data1.snapshot.value.toString());
    // int remainStock = stock - quantity;
    //
    // ref.child(productPath).update({'productStock': '$remainStock'});
  }

  void getSpecificCustomers({required String phoneNumber, required int due}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref(userId).child('Customers');
    ref.keepSynced(true);
    String? key;

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['phoneNumber'] == phoneNumber) {
          key = element.key;
          int previousDue = element.child('due').value.toString().toInt();
          print(previousDue);
          int totalDue = previousDue + due;
          ref.child(key!).update({'due': '$totalDue'});
        }
      }
    });
    // var data1 = ref.child('$key/due');
    // int previousDue = await data1.get().then((value) => value.value.toString().toInt());
    // print(previousDue);
    // int totalDue = previousDue + due;
    // ref.child(key!).update({'due': '$totalDue'});
  }
}
