import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: retailersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                LedgerCustomerDetailsScreen(
                                  customerModel: retailersList[index],
                                ).launch(context);
                              },
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(retailersList[index].profilePicture)),
                                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                              ),
                              title: Text(retailersList[index].customerName),
                              trailing: const Icon(Icons.arrow_forward_ios_sharp),
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: wholesalerList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                LedgerCustomerDetailsScreen(
                                  customerModel: wholesalerList[index],
                                ).launch(context);
                              },
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(wholesalerList[index].profilePicture)),
                                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                              ),
                              title: Text(wholesalerList[index].customerName),
                              trailing: const Icon(Icons.arrow_forward_ios_sharp),
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dealerList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                LedgerCustomerDetailsScreen(
                                  customerModel: dealerList[index],
                                ).launch(context);
                              },
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(dealerList[index].profilePicture)),
                                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                              ),
                              title: Text(dealerList[index].customerName),
                              trailing: const Icon(Icons.arrow_forward_ios_sharp),
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: supplierList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                LedgerCustomerDetailsScreen(
                                  customerModel: supplierList[index],
                                ).launch(context);
                              },
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(supplierList[index].profilePicture)),
                                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                              ),
                              title: Text(supplierList[index].customerName),
                              trailing: const Icon(Icons.arrow_forward_ios_sharp),
                            );
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }, error: (e, stack) {
            return Text(e.toString());
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
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
