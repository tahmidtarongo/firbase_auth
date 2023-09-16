import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/const_commas.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Provider/add_to_cart.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';

// ignore: must_be_immutable
class SaleProducts extends StatefulWidget {
  SaleProducts({Key? key, @required this.catName, this.customerModel}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  CustomerModel? customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _SaleProductsState createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String productPrice = '0';
  String sentProductPrice = '';

  @override
  void initState() {
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      final productList = ref.watch(productProvider);

      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          title: Text(
            lang.S.of(context).addItems,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: kMainColor,
          elevation: 0.0,
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (BuildContext bc) => [
          //       const PopupMenuItem(value: "/addPromoCode", child: Text('Add Promo Code')),
          //       const PopupMenuItem(value: "clear", child: Text('Cancel All Product')),
          //       const PopupMenuItem(value: "/settings", child: Text('Vat Doesn\'t Apply')),
          //     ],
          //     onSelected: (value) {
          //       value == 'clear'
          //           ? {
          //               providerData.clearCart(),
          //               providerData.clearDiscount(),
          //               const HomeScreen().launch(context, isNewTask: true)
          //             }
          //           : Navigator.pushNamed(context, '$value');
          //     },
          //   ),
          // ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   height: 60.0,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     color: kMainColor,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       // ignore: missing_required_param
                  //       providerData.getTotalAmount() <= 0
                  //           ? EasyLoading.showError('Cart Is Empty')
                  //           : SalesDetails(
                  //               customerName: widget.customerModel!.customerName,
                  //             ).launch(context);
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: Stack(
                  //             alignment: Alignment.center,
                  //             children: [
                  //               const Image(
                  //                 image: AssetImage('images/selected.png'),
                  //               ),
                  //               Text(
                  //                 items.toString(),
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 15.0,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Center(
                  //             child: Text(
                  //               providerData.getTotalAmount() <= 0
                  //                   ? 'Cart is empty'
                  //                   : 'Total: $currency${providerData.getTotalAmount().toString()}',
                  //               style: GoogleFonts.poppins(
                  //                 color: Colors.white,
                  //                 fontSize: 16.0,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         const Expanded(
                  //           flex: 1,
                  //           child: Icon(
                  //             Icons.arrow_forward,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTextField(
                            textFieldType: TextFieldType.NAME,
                            onChanged: (value) {
                              setState(() {
                                productCode = value;
                              });
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: lang.S.of(context).productCode,
                              hintText: productCode == '0000' || productCode == '-1' ? 'Scan product QR code' : productCode,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () => scanBarcodeNormal(),
                            child: Container(
                              height: 60.0,
                              width: 100.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: kGreyTextColor),
                              ),
                              child: const Image(
                                image: AssetImage('images/barcode.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  productList.when(data: (products) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (_, i) {
                          if (widget.customerModel!.type.contains('Retailer')) {
                            productPrice = products[i].productSalePrice;
                          } else if (widget.customerModel!.type.contains('Dealer')) {
                            if (products[i].productDealerPrice == '') {
                              productPrice = '0';
                            } else {
                              productPrice = products[i].productDealerPrice;
                            }
                          } else if (widget.customerModel!.type.contains('Wholesaler')) {
                            if (products[i].productWholeSalePrice == '') {
                              productPrice = '0';
                            } else {
                              productPrice = products[i].productWholeSalePrice;
                            }
                          } else if (widget.customerModel!.type.contains('Supplier')) {
                            productPrice = products[i].productPurchasePrice;
                          } else if (widget.customerModel!.type.contains('Guest')) {
                            productPrice = products[i].productSalePrice;
                          }
                          return GestureDetector(
                            onTap: () async {
                              if (products[i].productStock.toInt() <= 0) {
                                EasyLoading.showError('Out of stock');
                              } else {
                                if (widget.customerModel!.type.contains('Retailer')) {
                                  sentProductPrice = products[i].productSalePrice;
                                } else if (widget.customerModel!.type.contains('Dealer')) {
                                  sentProductPrice = products[i].productDealerPrice;
                                } else if (widget.customerModel!.type.contains('Wholesaler')) {
                                  sentProductPrice = products[i].productWholeSalePrice;
                                } else if (widget.customerModel!.type.contains('Supplier')) {
                                  sentProductPrice = products[i].productPurchasePrice;
                                } else if (widget.customerModel!.type.contains('Guest')) {
                                  sentProductPrice = products[i].productSalePrice;
                                }

                                AddToCartModel cartItem = AddToCartModel(
                                  productName: products[i].productName,
                                  subTotal: sentProductPrice,
                                  productPurchasePrice: products[i].productPurchasePrice,
                                  productId: products[i].productCode,
                                  productBrandName: products[i].brandName,
                                  stock: int.parse(products[i].productStock),
                                  uuid: products[i].productCode,
                                );
                                providerData.addToCartRiverPod(cartItem);
                                providerData.addProductsInSales(products[i]);
                                Navigator.pop(context);
                              }
                            },
                            child: ProductCard(
                              productTitle: products[i].productName,
                              productDescription: products[i].brandName,
                              productPrice: productPrice,
                              productImage: products[i].productPicture,
                              stock: products[i].productStock,
                            ).visible((products[i].productCode == productCode || productCode == '0000' || productCode == '-1') && productPrice != '0'),
                          );
                        });
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const Center(child: CircularProgressIndicator());
                  }),
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: Icons.arrow_forward,
        //   buttontext: 'Sales List',
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        //   onPressed: () {
        //     // ignore: missing_required_param
        //     providerData.getTotalAmount() <= 0
        //         ? EasyLoading.showError('Cart Is Empty')
        //         : SalesDetails(
        //             customerName: widget.customerModel!.customerName,
        //           ).launch(context);
        //   },
        // ),
      );
    });
  }
}

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard(
      {Key? key, required this.productTitle, required this.productDescription, required this.productPrice, required this.productImage, required this.stock})
      : super(key: key);

  // final Product product;
  String productImage, productTitle, productDescription, productPrice, stock;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  //image: DecorationImage(image: NetworkImage(widget.productImage), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(90.0),
                  color: kMainColor
                ),
                child: Center(child: Text(widget.productTitle.substring(0,1),style: const TextStyle(color: Colors.white),)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.productTitle,
                    style: GoogleFonts.jost(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Stock: ${widget.stock.toInt() - quantity}',
                    style: GoogleFonts.jost(
                      fontSize: 15.0,
                      color: kGreyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '$currency${widget.productPrice}',
              style: GoogleFonts.jost(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}
