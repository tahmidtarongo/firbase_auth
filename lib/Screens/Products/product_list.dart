import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import 'add_product.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> productCodeList = [];
  List<String> productNameList = [];
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(productProvider);
      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Product List',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: providerData.when(data: (products) {
              return products.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        productCodeList.add(products[i].productCode.removeAllWhiteSpace().toLowerCase());
                        productNameList.add(products[i].productName.removeAllWhiteSpace().toLowerCase());
                        return ListTile(
                          onTap: () {
                            UpdateProduct(
                              productModel: products[i],
                              productCodeList: productCodeList,
                              productNameList: productNameList,
                            ).launch(context);
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(90)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    products[i].productPicture,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            // child: CachedNetworkImage(
                            //   imageUrl: products[i].productPicture,
                            //   placeholder: (context, url) => const SizedBox(height: 50, width: 50, ),
                            //   errorWidget: (context, url, error) => const Icon(Icons.error),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          title: Text(products[i].productName),
                          subtitle: Text("Stock : ${products[i].productStock}"),
                          trailing: Text(
                            "$currency ${products[i].productSalePrice}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      })
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
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: ButtonGlobal(
            iconWidget: Icons.add,
            buttontext: 'Add New Product',
            iconColor: Colors.white,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
            onPressed: () {
              print(productNameList);
              print(productCodeList);
              AddProduct(
                productNameList: productNameList,
                productCodeList: productCodeList,
              ).launch(context);
            },
          ),
        ),
      );
    });
  }
}
