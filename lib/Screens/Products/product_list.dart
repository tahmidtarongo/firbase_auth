// ignore_for_file: unused_result

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../../model/product_model.dart';
import 'add_product.dart';
import '../../const_commas.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> with TickerProviderStateMixin {
  List<String> productCodeList = [];
  List<String> productNameList = [];
  String? productName;
  String categoryName = 'All';
  int count = 0;
  List<String> category = ['All'];
  TabController? tabController;

  String phoneNumber = '';
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

  void deleteProduct({required String productCode, required WidgetRef updateProduct, required BuildContext context}) async {
    EasyLoading.show(status: 'Deleting..');
    String customerKey = '';
    await FirebaseDatabase.instance.ref(await getUserID()).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == productCode) {
          customerKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("${await getUserID()}/Products/$customerKey");
    await ref.remove();
    updateProduct.refresh(productProvider);
    Navigator.pop(context);
    EasyLoading.showSuccess('Done');
  }

  @override
  void initState() {
    getConnectivity();
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(productProvider);
      final categoryData = ref.watch(categoryProvider);
      return categoryData.when(data: (categoryList) {
        for (int i = 0; i < categoryList.length; i++) {
          category.contains(categoryList[i].categoryName) ? null : category.add(categoryList[i].categoryName);
        }
        tabController = TabController(length: category.length, vsync: this);
        return DefaultTabController(
          initialIndex: 0,
          length: category.length,
          child: Scaffold(
            backgroundColor: kMainColor,
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ).onTap(() async {
                await Future.delayed(const Duration(microseconds: 100)).then((value) => const Home().launch(context));
              }),
              title: Text(
                'Product List',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: WillPopScope(
              onWillPop: () async {
                await Future.delayed(const Duration(microseconds: 100)).then((value) {
                  if (mounted) {
                    const Home().launch(context);
                    return true;
                  } else {
                    return false;
                  }
                });
                return false;
              },
              child: Container(
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      TabBar(
                        controller: tabController,
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        tabs: List.generate(
                          category.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              category[index],
                              style: const TextStyle(color: kMainColor, fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: AppTextField(
                          textFieldType: TextFieldType.NAME,
                          onChanged: (value) {
                            setState(() {
                              productName = value;
                            });
                          },
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: lang.S.of(context).productName,
                              hintText: lang.S.of(context).enterProductName,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.search)),
                        ),
                      ),
                      providerData.when(data: (products) {
                        return products.isNotEmpty
                            ? SizedBox(
                                height: products.length * 75,
                                child: TabBarView(
                                  controller: tabController,
                                  children: List.generate(
                                    category.length,
                                    (index) => ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: products.length,
                                      itemBuilder: (_, i) {
                                        productCodeList.add(products[i].productCode.removeAllWhiteSpace().toLowerCase());
                                        productNameList.add(products[i].productName.removeAllWhiteSpace().toLowerCase());
                                        return ListTile(
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration:
                                                BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(products[i].productPicture))),
                                          ),
                                          title: Text(products[i].productName),
                                          subtitle: Text("Stock : ${myFormat.format(int.tryParse(products[i].productStock) ?? 0)}"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "$currency ${myFormat.format(int.tryParse(products[i].productSalePrice) ?? 0)}",
                                                // "$currency ${products[i].productSalePrice}",
                                                style: const TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                child: PopupMenuButton(
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (BuildContext bc) => [
                                                    PopupMenuItem(
                                                        child: InkWell(
                                                      onTap: () {
                                                        UpdateProduct(
                                                          productModel: products[i],
                                                          productCodeList: productCodeList,
                                                          productNameList: productNameList,
                                                        ).launch(context);
                                                      },
                                                      child: const Row(
                                                        children: [
                                                          Icon(FeatherIcons.edit3, size: 18.0, color: Colors.black),
                                                          SizedBox(width: 4.0),
                                                          Text(
                                                            'Edit',
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    PopupMenuItem(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          increseStockPopUp(context, products, i, ref);
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons.add, size: 18.0, color: Colors.black),
                                                            SizedBox(width: 4.0),
                                                            Text(
                                                              'Increase Stock',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          deleteProduct(productCode: products[i].productCode, updateProduct: ref, context: bc);
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons.delete, size: 18.0, color: Colors.black),
                                                            SizedBox(width: 4.0),
                                                            Text(
                                                              'Delete',
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  onSelected: (value) {
                                                    Navigator.pushNamed(context, '$value');
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                        height: 18,
                                                        width: 18,
                                                        alignment: Alignment.centerRight,
                                                        child: const Icon(
                                                          Icons.more_vert_sharp,
                                                          size: 20,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                            .visible(productName.isEmptyOrNull ? true : products[i].productName.toUpperCase().contains(productName!.toUpperCase()))
                                            .visible(category[index] == 'All' ? true : products[i].productCategory == category[index]);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: EmptyScreenWidget(),
                              ));
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
            bottomNavigationBar: Container(
              color: Colors.white,
              child: ButtonGlobal(
                iconWidget: Icons.add,
                buttontext: lang.S.of(context).addNewProduct,
                iconColor: Colors.white,
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                onPressed: () {
                  AddProduct(
                    productNameList: productNameList,
                    productCodeList: productCodeList,
                  ).launch(context);
                },
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Scaffold(
          body: Center(
            child: Text(e.toString()),
          ),
        );
      }, loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    });
  }

  Future<dynamic> increseStockPopUp(BuildContext context1, List<ProductModel> products, int i, WidgetRef pref) {
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');
    String productKey = '';
    ref.keepSynced(true);

    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == products[i].productCode) {
          productKey = element.key.toString();
        }
      }
    });
    return showDialog(
        context: context,
        builder: (_) {
          ProductModel tempProductModel = products[i];
          TextEditingController stockController = TextEditingController(text: tempProductModel.productStock);
          TextEditingController salePriceController = TextEditingController(text: tempProductModel.productSalePrice);
          TextEditingController purchaseController = TextEditingController(text: tempProductModel.productPurchasePrice);
          TextEditingController wholeSellerController = TextEditingController(text: tempProductModel.productWholeSalePrice);
          TextEditingController dealerController = TextEditingController(text: tempProductModel.productDealerPrice);
          return AlertDialog(
              content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Increase Stock',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: kMainColor,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[i].productName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            products[i].brandName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            lang.S.of(context).stocks,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            tempProductModel.productStock,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: stockController,
                          textFieldType: TextFieldType.NUMBER,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).quantity,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: purchaseController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).purchasePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: salePriceController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).salePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: wholeSellerController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).wholeSalePrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: dealerController,
                          keyboardType: TextInputType.number,
                          textFieldType: TextFieldType.NAME,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: lang.S.of(context).dealerPrice,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (tempProductModel.productStock != '0') {
                        DatabaseReference ref = FirebaseDatabase.instance.ref("$constUserId/Products/$productKey");
                        ref.keepSynced(true);
                        ref.update({
                          'productStock': stockController.text,
                          'productSalePrice': salePriceController.text,
                          'productPurchasePrice': purchaseController.text,
                          'productWholeSalePrice': wholeSellerController.text,
                          'productDealerPrice': dealerController.text,
                        });
                        EasyLoading.showSuccess('Done');
                        pref.refresh(productProvider);
                        pref.refresh(categoryProvider);
                        Navigator.pop(context);
                        Navigator.pop(context1);
                      } else {
                        EasyLoading.showError('Please add quantity');
                      }
                    },
                    child: Container(
                      height: 60,
                      width: context.width(),
                      decoration: const BoxDecoration(color: kMainColor, borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          lang.S.of(context).save,
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
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
