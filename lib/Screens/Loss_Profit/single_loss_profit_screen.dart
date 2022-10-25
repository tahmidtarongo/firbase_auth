import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';
import '../../model/transition_model.dart';

class SingleLossProfitScreen extends StatefulWidget {
  const SingleLossProfitScreen({Key? key, required this.transactionModel, required this.profit, required this.totalQuantity}) : super(key: key);

  final TransitionModel transactionModel;
  final double profit;
  final int totalQuantity;

  @override
  State<SingleLossProfitScreen> createState() => _SingleLossProfitScreenState();
}

class _SingleLossProfitScreenState extends State<SingleLossProfitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loss/Profit Details',
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Invoice # ${widget.transactionModel.invoiceNumber}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.transactionModel.customerName),
                  Text(
                    "Date: ${DateFormat.yMMMd().format(DateTime.parse(widget.transactionModel.purchaseDate))}",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mobile: ${widget.transactionModel.customerPhone}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    DateFormat.jm().format(DateTime.parse(widget.transactionModel.purchaseDate)),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                color: kMainColor.withOpacity(0.2),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Product',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Profit',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Loss',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: widget.transactionModel.productList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    double purchasePrice = double.parse(widget.transactionModel.productList![index].productPurchasePrice.toString()) *
                        double.parse(widget.transactionModel.productList![index].quantity.toString());
                    double salePrice = double.parse(widget.transactionModel.productList![index].subTotal.toString()) *
                        double.parse(widget.transactionModel.productList![index].quantity.toString());
                    double profit = salePrice - purchasePrice;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.transactionModel.productList![index].productName.toString(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                widget.transactionModel.productList![index].quantity.toString(),
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  !profit.isNegative ? "\$${profit.abs().toString()}" : '0',
                                  style: GoogleFonts.poppins(),
                                ),
                              )),
                          Expanded(
                            child: Center(
                              child: Text(
                                profit.isNegative ? "\$${profit.abs().toString()}" : '0',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.profit.isNegative
                              ? 'Discount    \$${(widget.transactionModel.discountAmount! + widget.profit).abs()} + \$${widget.transactionModel.discountAmount} = \$${widget.profit.abs()}'
                              : 'Discount    \$${widget.transactionModel.discountAmount! + widget.profit} - \$${widget.transactionModel.discountAmount} = \$${widget.profit}',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        "",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: kMainColor.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Total',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.totalQuantity.toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "\$${!widget.profit.isNegative ? widget.profit.toString() : '0'}",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          )),
                      Text(
                        "\$${widget.profit.isNegative ? widget.profit.abs().toString() : '0'}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}