import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
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

class _ProductListState extends State<ProductList> with TickerProviderStateMixin{
  List<String> productCodeList = [];
  List<String> productNameList = [];
  String? productName;
  String categoryName = 'All';
  int count = 0;
  List<String> category = ['All'];
  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(productProvider);
      final categoryData = ref.watch(categoryProvider);
      return categoryData.when(data: (categoryList) {

        for(int i = 0;i< categoryList.length;i++){
         category.contains(categoryList[i].categoryName)? null : category.add(categoryList[i].categoryName);
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
              leading: const Icon(Icons.arrow_back,color: Colors.white,).onTap(() => const Home().launch(context)),
              title: Text(
                'Product List',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: WillPopScope(
              onWillPop: () async => await const Home().launch(context),
              child: Container(
                alignment: Alignment.topCenter,
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
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
                              style: const TextStyle(color: kMainColor,fontSize: 18.0),
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
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'Product Name',
                            hintText: 'Enter Product Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search)
                          ),
                        ),
                      ),
                      providerData.when(data: (products) {
                        return products.isNotEmpty
                            ? SizedBox(
                          height: context.height()/1.5,
                              child: TabBarView(
                          controller: tabController,
                              children:
                                List.generate(category.length, (index) => ListView.builder(

                                    itemCount: products.length,
                                    itemBuilder: (_, i) {
                                      productCodeList.add(products[i].productCode.removeAllWhiteSpace().toLowerCase());
                                      productNameList.add(products[i].productName.removeAllWhiteSpace().toLowerCase());
                                      return SizedBox(
                                        child: ListTile(
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
                                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(90)), color: kMainColor),
                                            child: Center(
                                              child: Text(
                                                products[i].productName.substring(0, 1).toUpperCase(),
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          title: Text(products[i].productName),
                                          subtitle: Text("Stock : ${products[i].productStock}"),
                                          trailing: Text(
                                            "$currency ${products[i].productSalePrice}",
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ).visible(productName.isEmptyOrNull ? true : products[i].productName.toUpperCase().contains(productName!.toUpperCase())),
                                      ).visible(category[index] == 'All' ? true : products[i].productCategory == category[index] );
                                    }))),
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
                buttontext: 'Add New Product',
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
}
