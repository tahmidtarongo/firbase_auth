import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../currency.dart';
import '../../empty_screen_widget.dart';
import '../Customers/Model/customer_model.dart';
import 'ledger_customer_details_screen.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  List<CustomerModel> retailersList = [];
  List<CustomerModel> wholesalerList = [];
  List<CustomerModel> dealerList = [];
  List<CustomerModel> supplierList = [];
  double totalSale = 0;

  Future<void> customerData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<CustomerModel> customerList = [];
    await FirebaseDatabase.instance.ref(userId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        customerList.add(CustomerModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });

    for (var element in customerList) {
      if (element.type.contains('Retailer')) {
        retailersList.add(element);
      }
      if (element.type.contains('Wholesaler')) {
        wholesalerList.add(element);
      }
      if (element.type.contains('Dealer')) {
        dealerList.add(element);
      }
      if (element.type.contains('Supplier')) {
        supplierList.add(element);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final customerData = ref.watch(customerProvider);
      return DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            title: Text(
              'Ledger',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            backgroundColor: kMainColor,
            elevation: 0.0,
          ),
          body: customerData.when(data: (customer) {
            return Container(
              alignment: Alignment.topCenter,
              decoration:
                  const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                      indicatorColor: Colors.blueAccent,
                      labelColor: kMainColor,
                      tabs: [
                        Tab(
                          text: 'Retailer',
                        ),
                        Tab(
                          text: 'Wholesaler',
                        ),
                        Tab(
                          text: 'Dealer',
                        ),
                        Tab(
                          text: 'Supplier',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: context.height(),
                      child: TabBarView(children: [
                        retailersList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: retailersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      LedgerCustomerDetailsScreen(
                                        customerModel: retailersList[index],
                                      ).launch(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircleAvatar(
                                              foregroundColor: Colors.blue,
                                              backgroundColor: Colors.white,
                                              radius: 70.0,
                                              child: ClipOval(
                                                child: Image.network(
                                                  retailersList[index].profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 120.0,
                                                  height: 120.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            retailersList[index].customerName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '$currency ${retailersList[index].dueAmount}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Due',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFFff5f00),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ).visible(retailersList[index].dueAmount != '' && retailersList[index].dueAmount != '0'),
                                          const SizedBox(width: 20),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(60),
                                child: EmptyScreenWidget(),
                              ),
                        wholesalerList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: wholesalerList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      LedgerCustomerDetailsScreen(
                                        customerModel: wholesalerList[index],
                                      ).launch(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircleAvatar(
                                              foregroundColor: Colors.blue,
                                              backgroundColor: Colors.white,
                                              radius: 70.0,
                                              child: ClipOval(
                                                child: Image.network(
                                                  wholesalerList[index].profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 120.0,
                                                  height: 120.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            wholesalerList[index].customerName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '$currency ${wholesalerList[index].dueAmount}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Due',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFFff5f00),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ).visible(wholesalerList[index].dueAmount != '' && wholesalerList[index].dueAmount != '0'),
                                          const SizedBox(width: 20),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(padding: EdgeInsets.all(60), child: EmptyScreenWidget()),
                        dealerList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: dealerList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      LedgerCustomerDetailsScreen(
                                        customerModel: dealerList[index],
                                      ).launch(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircleAvatar(
                                              foregroundColor: Colors.blue,
                                              backgroundColor: Colors.white,
                                              radius: 70.0,
                                              child: ClipOval(
                                                child: Image.network(
                                                  dealerList[index].profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 120.0,
                                                  height: 120.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Text(
                                            dealerList[index].customerName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '$currency ${dealerList[index].dueAmount}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Due',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFFff5f00),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ).visible(dealerList[index].dueAmount != '' && dealerList[index].dueAmount != '0'),
                                          const SizedBox(width: 20),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(padding: EdgeInsets.all(60), child: EmptyScreenWidget()),
                        supplierList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: supplierList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      LedgerCustomerDetailsScreen(
                                        customerModel: supplierList[index],
                                      ).launch(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircleAvatar(
                                              foregroundColor: Colors.blue,
                                              backgroundColor: Colors.white,
                                              radius: 70.0,
                                              child: ClipOval(
                                                child: Image.network(
                                                  supplierList[index].profilePicture,
                                                  fit: BoxFit.cover,
                                                  width: 120.0,
                                                  height: 120.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                supplierList[index].customerName,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '$currency ${supplierList[index].dueAmount}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Due',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFFff5f00),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ).visible(supplierList[index].dueAmount != '' && supplierList[index].dueAmount != '0'),
                                          const SizedBox(width: 20),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(padding: EdgeInsets.all(60), child: EmptyScreenWidget()),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }, error: (e, stack) {
            return Text(e.toString());
          }, loading: () {
            return Container(
              alignment: Alignment.topCenter,
              decoration:
                  const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),),
              child: const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
            );
          }),
        ),
      );
    });
  }
}

// ignore: must_be_immutable
class ReportCard extends StatelessWidget {
  ReportCard({
    Key? key,
    required this.pressed,
    required this.iconPath,
    required this.title,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var pressed;
  String iconPath, title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage(
                  iconPath,
                ),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: kMainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
