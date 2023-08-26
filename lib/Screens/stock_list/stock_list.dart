import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Provider/product_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import 'dart:io';
import '../../empty_screen_widget.dart';

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;
  String? productName;
  int count = 0;
  @override
  void initState() {

    super.initState();
  }

  NumberFormat decimalFormat = NumberFormat.decimalPattern('en_US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).currentStock,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);

        return Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      providerData.when(data: (product) {

                        if(count == 0){
                          count++;
                          for (var element in product) {
                            totalStock = totalStock + element.productStock.toInt();
                            totalSalePrice = totalSalePrice + (element.productStock.toInt() * element.productSalePrice.toInt());
                            totalParPrice = totalParPrice + (element.productStock.toInt() * element.productSalePrice.toInt());
                          }
                        }
                        return product.isNotEmpty
                            ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: kMainColor.withOpacity(0.1),
                                    border: Border.all(width: 1, color: kMainColor),
                                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          totalStock.toString(),
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                         Text(
                                          lang.S.of(context).totalStock,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 60,
                                      color: kMainColor,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                        currency + totalParPrice.toInt().toString(),
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                         Text(
                                           lang.S.of(context).totalPrice,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                onChanged: (value) {
                                  setState(() {
                                    productName = value;
                                  });
                                },
                                decoration:  InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  labelText: lang.S.of(context).productName,
                                  hintText: lang.S.of(context).enterProductName,
                                  prefixIcon: const Icon(Icons.search),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: kMainColor.withOpacity(0.2),
                            //     borderRadius: const BorderRadius.only(
                            //       topLeft: Radius.circular(0),
                            //       topRight: Radius.circular(0),
                            //     ),
                            //   ),
                            //   padding: const EdgeInsets.all(20),
                            //   child: Row(
                            //     children:  [
                            //       Expanded(
                            //         flex: 2,
                            //         child: Text(
                            //           lang.S.of(context).product,
                            //           style: const TextStyle(fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         flex: 2,
                            //         child: Text(
                            //           lang.S.of(context).quantity,
                            //           style: const TextStyle(fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         flex: 2,
                            //         child: Text(
                            //           lang.S.of(context).purchase,
                            //           style: const TextStyle(fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       Text(
                            //         lang.S.of(context).sales,
                            //         style: const TextStyle(fontWeight: FontWeight.bold),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 10,),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith((states) => kMainColor.withOpacity(0.2)),
                                border: TableBorder.all(color: kBorderColorTextField,width: 0.5),
                                columns:  <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).product,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).qty,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).purchase,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      lang.S.of(context).sales,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  product.length,
                                      (index) => DataRow(cells: [
                                    DataCell(Padding(
                                      padding: product.last == product[index]
                                          ? const EdgeInsets.only(top: 4)
                                          : const EdgeInsets.only(top: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product[index].productName,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            product[index].brandName,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              color: product[index].productStock.toInt() < 20 ? Colors.red : kGreyTextColor,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                    DataCell(Text(
                                      product[index].productStock,
                                      style: GoogleFonts.poppins(
                                        color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                      ),
                                    ),),
                                    DataCell(Text(
                                      '$currency${product[index].productPurchasePrice}',
                                      style: GoogleFonts.poppins(
                                        color: product[index].productStock.toInt() < 10 ? Colors.red : Colors.black,
                                      ),
                                    ),),
                                    DataCell(Text(
                                      '$currency ${product[index].productSalePrice}' ,
                                      style: GoogleFonts.poppins(
                                        color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                                      ),
                                    )),
                                  ]),
                                ),
                              ),
                            ),

                            // ListView.builder(
                            //     itemCount: product.length,
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (context, index) {
                            //       return Padding(
                            //         padding: const EdgeInsets.all(10.0),
                            //         child: Row(
                            //           children: [
                            //             Column(
                            //               mainAxisAlignment: MainAxisAlignment.start,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   product[index].productName,
                            //                   textAlign: TextAlign.start,
                            //                   style: GoogleFonts.poppins(
                            //                     color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                            //                     fontSize: 16.0,
                            //                   ),
                            //                 ),
                            //                 Text(
                            //                   product[index].brandName,
                            //                   textAlign: TextAlign.start,
                            //                   style: GoogleFonts.poppins(
                            //                     color: product[index].productStock.toInt() < 20 ? Colors.red : kGreyTextColor,
                            //                     fontSize: 12.0,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //             Text(
                            //               product[index].productStock,
                            //               style: GoogleFonts.poppins(
                            //                 color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                            //               ),
                            //             ),
                            //             Text(
                            //               '$currency${product[index].productPurchasePrice}',
                            //               style: GoogleFonts.poppins(
                            //                 color: product[index].productStock.toInt() < 10 ? Colors.red : Colors.black,
                            //               ),
                            //             ),
                            //             Text(
                            //               '$currency${product[index].productSalePrice}',
                            //               style: GoogleFonts.poppins(
                            //                 color: product[index].productStock.toInt() < 20 ? Colors.red : Colors.black,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ).visible(productName.isEmptyOrNull ? true : product[index].productName.toUpperCase().contains(productName!.toUpperCase()));
                            //     }),
                          ],
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }}



