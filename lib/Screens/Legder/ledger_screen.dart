import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Legder/retailer_ledger_customers_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../Customers/Model/customer_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(customerProvider);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ledger',
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
        body: providerData.when(data: (customer) {
          for (var element in customer) {
            if (element.type.contains('Retailer')) {
              retailersList.add(element);
            }
            if (element.type.contains('Wholesaler')) {
              wholesalerList.add(element);
            }
            if (element.type.contains('Dealer')) {
              dealerList.add(element);
            }
          }
          return Column(
            children: [
              ReportCard(
                  pressed: () {
                    RetailerLedgerScreen(
                      retailers: retailersList,
                      type: 'Retailers',
                    ).launch(context);
                  },
                  iconPath: 'images/sustomerpic.jpeg',
                  title: 'Retailers'),
              ReportCard(
                  pressed: () {
                    RetailerLedgerScreen(
                      retailers: wholesalerList,
                      type: 'Wholesalers',
                    ).launch(context);
                  },
                  iconPath: 'images/sustomerpic.jpeg',
                  title: 'Wholesaler'),
              ReportCard(
                  pressed: () {
                    RetailerLedgerScreen(
                      retailers: dealerList,
                      type: 'Dealers',
                    ).launch(context);
                  },
                  iconPath: 'images/sustomerpic.jpeg',
                  title: 'Dealer'),
            ],
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        }),
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
