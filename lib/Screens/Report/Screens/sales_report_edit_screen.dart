import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_Edit_invoice_add_products.dart';
import 'package:mobile_pos/model/personal_information_model.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:mobile_pos/model/transition_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Provider/printer_provider.dart';
import '../../../Provider/product_provider.dart';
import '../../../constant.dart';
import '../../../model/add_to_cart_model.dart';
import '../../Customers/Model/customer_model.dart';
import '../../invoice_details/sales_invoice_details_screen.dart';

// ignore: must_be_immutable
class SalesReportEditScreen extends StatefulWidget {
  SalesReportEditScreen({Key? key, required this.transitionModel}) : super(key: key);
  TransitionModel transitionModel;

  @override
  State<SalesReportEditScreen> createState() => _SalesReportEditScreenState();
}

class _SalesReportEditScreenState extends State<SalesReportEditScreen> {
  @override
  void initState() {
    pastProducts = widget.transitionModel.productList!;
    // TODO: implement initState
    super.initState();
    InternetPopup().initialize(context: context);
    transitionModel = widget.transitionModel;
    paidAmount = double.parse(widget.transitionModel.totalAmount.toString()) -
        double.parse(widget.transitionModel.dueAmount.toString()) +
        double.parse(widget.transitionModel.returnAmount.toString());
    discountAmount = widget.transitionModel.discountAmount!;
    dropdownValue = widget.transitionModel.paymentType;
    discountText.text = discountAmount.toString();
    paidText.text = paidAmount.toString();
    returnAmount = widget.transitionModel.returnAmount!;
    invoice = widget.transitionModel.invoiceNumber.toInt();
  }

  TextEditingController discountText = TextEditingController();
  TextEditingController paidText = TextEditingController();

  int invoice = 0;
  double paidAmount = 0;
  double discountAmount = 0;
  double returnAmount = 0;
  double dueAmount = 0;
  double subTotal = 0;

  List<AddToCartModel> pastProducts = [];
  List<AddToCartModel> presentProducts = [];
  List<AddToCartModel> increaseStockList = [];
  List<AddToCartModel> decreaseStockList = [];

  String? dropdownValue = 'Cash';
  String? selectedPaymentType;

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

  late TransitionModel transitionModel = TransitionModel(
    customerName: widget.transitionModel.customerName,
    customerPhone: '',
    customerType: '',
    invoiceNumber: invoice.toString(),
    purchaseDate: DateTime.now().toString(),
  );
  DateTime selectedDate = DateTime.now();
  bool doNotCheckProducts = false;

  @override
  Widget build(BuildContext context) {
    print(invoice);
    return Consumer(builder: (context, consumerRef, __) {
      final providerData = consumerRef.watch(cartNotifier);
      final printerData = consumerRef.watch(printerProviderNotifier);
      final personalData = consumerRef.watch(profileDetailsProvider);
      final productList = consumerRef.watch(productProvider);

      !doNotCheckProducts
          ? productList.value?.forEach((products) {
              String sentProductPrice = '';
              widget.transitionModel.productList?.forEach((element) {
                if (element.productId == products.productCode) {
                  if (widget.transitionModel.customerType.contains('Retailer')) {
                    sentProductPrice = products.productSalePrice;
                  } else if (widget.transitionModel.customerType.contains('Dealer')) {
                    sentProductPrice = products.productDealerPrice;
                  } else if (widget.transitionModel.customerType.contains('Wholesaler')) {
                    sentProductPrice = products.productWholeSalePrice;
                  } else if (widget.transitionModel.customerType.contains('Supplier')) {
                    sentProductPrice = products.productPurchasePrice;
                  } else if (widget.transitionModel.customerType.contains('Guest')) {
                    sentProductPrice = products.productSalePrice;
                  }

                  AddToCartModel cartItem = AddToCartModel(
                    productName: products.productName,
                    subTotal: sentProductPrice,
                    quantity: element.quantity,
                    productId: products.productCode,
                    productBrandName: products.brandName,
                    stock: int.parse(products.productStock),
                  );
                  providerData.addToCartRiverPod(cartItem);
                  providerData.addProductsInSales(products);
                }
              });

              if (widget.transitionModel.productList?.length == providerData.cartItemList.length) {
                doNotCheckProducts = true;
              }
            })
          : null;
      return personalData.when(data: (data) {
        // invoice = data.invoiceCounter!.toInt();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Add Sales',
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
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
                          initialValue: widget.transitionModel.invoiceNumber,
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
                          initialValue: widget.transitionModel.purchaseDate,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Date',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {},
                              icon: const Icon(FeatherIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    readOnly: true,
                    initialValue: widget.transitionModel.customerName,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Customer Name',
                      border: OutlineInputBorder(),
                    ),
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
                              int i =0;
                              for (var element in pastProducts) {

                                if (element.productId != providerData.cartItemList[index].productId) {
                                  i++;

                                }
                                if(i == pastProducts.length){
                                   decreaseStockList.contains(providerData.cartItemList[index].productId)?null :decreaseStockList.add(providerData.cartItemList[index]);
                                }
                              }

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
                      EditSaleInvoiceSaleProducts(
                        catName: null,
                        customerModel: CustomerModel(widget.transitionModel.customerName, widget.transitionModel.customerPhone,
                            widget.transitionModel.customerType, '', '', 'customerAddress', ''),
                        transitionModel: widget.transitionModel,
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
                              SizedBox(
                                width: context.width() / 4,
                                child: TextField(
                                  controller: discountText,
                                  onChanged: (value) {
                                    if (value == '') {
                                      setState(() {
                                        discountAmount = 0;
                                      });
                                    } else {
                                      if (value.toInt() <= providerData.getTotalAmount()) {
                                        setState(() {
                                          discountAmount = double.parse(value);
                                        });
                                      } else {
                                        discountText.clear();
                                        setState(() {
                                          discountAmount = 0;
                                        });
                                        EasyLoading.showError('Enter a valid Discount');
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
                                  controller: paidText,
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
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            if (providerData.cartItemList.isNotEmpty) {
                              try {
                                // EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                                final userId = FirebaseAuth.instance.currentUser!.uid;

                                dueAmount <= 0 ? transitionModel.isPaid = true : transitionModel.isPaid = false;
                                dueAmount <= 0 ? transitionModel.dueAmount = 0 : transitionModel.dueAmount = dueAmount;
                                returnAmount < 0 ? transitionModel.returnAmount = returnAmount.abs() : transitionModel.returnAmount = 0;
                                transitionModel.discountAmount = discountAmount;
                                transitionModel.totalAmount = subTotal;
                                transitionModel.productList = providerData.cartItemList;
                                transitionModel.paymentType = dropdownValue;
                                transitionModel.invoiceNumber = invoice.toString();

                                ///________updateInvoice__________________
                                // String? key;
                                // await FirebaseDatabase.instance.ref(userId).child('Sales Transition').orderByKey().get().then((value) {
                                //   for (var element in value.children) {
                                //     final t = TransitionModel.fromJson(jsonDecode(jsonEncode(element.value)));
                                //     if (transitionModel.invoiceNumber == t.invoiceNumber) {
                                //       key = element.key;
                                //     }
                                //   }
                                // });
                                // await FirebaseDatabase.instance.ref(userId).child('Sales Transition').child(key!).update(transitionModel.toJson());

                                ///__________StockMange_________________________________________________

                                presentProducts = transitionModel.productList!;

                                for (var pastElement in pastProducts) {
                                  int i = 0;
                                  for (var futureElement in presentProducts) {
                                    if (pastElement.productId == futureElement.productId) {
                                      if (pastElement.quantity < futureElement.quantity && pastElement.quantity != futureElement.quantity) {
                                        decreaseStockList.contains(pastElement.productId)
                                            ? null
                                            : decreaseStockList.add(
                                                AddToCartModel(
                                                  productName: pastElement.productName,
                                                  productId: pastElement.productId,
                                                  quantity: futureElement.quantity.toInt() - pastElement.quantity.toInt(),
                                                ),
                                              );
                                      } else if (pastElement.quantity > futureElement.quantity && pastElement.quantity != futureElement.quantity) {
                                        increaseStockList.contains(pastElement.productId)
                                            ? null
                                            : increaseStockList.add(
                                                AddToCartModel(
                                                  productName: pastElement.productName,
                                                  productId: pastElement.productId,
                                                  quantity: pastElement.quantity - futureElement.quantity,
                                                ),
                                              );
                                      }
                                      break;
                                    } else {
                                      i++;
                                      if (i == presentProducts.length) {
                                        increaseStockList.add(
                                          AddToCartModel(
                                            productName: pastElement.productName,
                                            productId: pastElement.productId,
                                            quantity: pastElement.quantity,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                                // for (var futureElement in presentProducts) {
                                //   int i = 0;
                                //   for (var pastElement in pastProducts) {
                                //     if (futureElement.productId != pastElement.productId) {
                                //       i++;
                                //     }
                                //     if (i == pastProducts.length) {
                                //       decreaseStockList.add(
                                //         AddToCartModel(
                                //           productName: pastElement.productName,
                                //           productId: pastElement.productId,
                                //           quantity: pastElement.quantity,
                                //         ),
                                //       );
                                //     }
                                //   }
                                // }
                                // for (var futureElement in presentProducts) {
                                //   for (var pastElement in pastProducts) {
                                //     if (futureElement.productId != pastElement.productId) {
                                //       decreaseStock.add(
                                //         CartItem(
                                //           productName: pastElement.productName,
                                //           productId: pastElement.productId,
                                //           quantity: pastElement.quantity,
                                //         ),
                                //       );
                                //     }
                                //     break;
                                //   }
                                // }
                                // transitionModel.productList?.forEach((futureElement) {
                                //   widget.transitionModel.productList?.forEach((pastElement) {
                                //     decreaseStock.add(CartItem(
                                //       productName: pastElement.productName,
                                //       productId: pastElement.productId,
                                //       quantity: pastElement.quantity,
                                //     ));
                                //     return;
                                //   });
                                // });

                                print('decreaseStock');
                                for (var element in decreaseStockList) {
                                  print(element.productName);
                                  print(element.quantity);
                                }
                                print('increaseStock');
                                for (var element in increaseStockList) {
                                  print(element.productName);
                                  print(element.quantity);
                                }

                                // for (var element in providerData.cartItemList) {
                                //   decreaseStock(element.productId, element.quantity);
                                // }

                                ///_________DueUpdate______________________________________________________
                                // getSpecificCustomers(phoneNumber: widget.customerModel.phoneNumber, due: transitionModel.dueAmount!.toInt());

                                EasyLoading.dismiss();
                                // ignore: use_build_context_synchronously
                                // SalesInvoiceDetails(
                                //   transitionModel: transitionModel,
                                //   personalInformationModel: PersonalInformationModel(),
                                // ).launch(context);
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
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
    final ref = FirebaseDatabase.instance.ref('$userId/Products/');

    var data = await ref.orderByChild('productCode').equalTo(productCode).once();
    String productPath = data.snapshot.value.toString().substring(1, 21);

    var data1 = await ref.child('$productPath/productStock').once();
    int stock = int.parse(data1.snapshot.value.toString());
    int remainStock = stock - quantity;

    ref.child(productPath).update({'productStock': '$remainStock'});
  }

  void decreaseSubscriptionSale() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Subscription/saleNumber');
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    FirebaseDatabase.instance.ref('$userId/Subscription').update({'saleNumber': afterSale});
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

    int totalDue = previousDue + due;
    ref.child(key!).update({'due': '$totalDue'});
  }
}
