import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/add_to_cart.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/Screens/Customers/add_customer.dart';
import 'package:mobile_pos/Screens/Sales/add_sales.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../constant.dart';
import '../../currency.dart';

class SalesContact extends StatefulWidget {
  const SalesContact({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesContactState createState() => _SalesContactState();
}

class _SalesContactState extends State<SalesContact> {
  Color color = Colors.black26;
  String searchCustomer = '';
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(customerProvider);
      final cart = ref.watch(cartNotifier);
      return Scaffold(
        backgroundColor: kMainColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            'Choose a Customer',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: providerData.when(data: (customer) {
                return customer.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: AppTextField(
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Search',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: kGreyTextColor.withOpacity(0.5),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchCustomer = value;
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              CustomerModel guestModel = CustomerModel(
                                'Guest',
                                'Guest',
                                'Guest',
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                'Guest',
                                'Guest',
                                '0',
                                '0',
                                '',
                              );
                              AddSalesScreen(customerModel: guestModel).launch(context);
                              cart.clearCart();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: CircleAvatar(
                                      foregroundColor: Colors.blue,
                                      backgroundColor: kMainColor,
                                      radius: 70.0,
                                      child: Text('G',style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Walk-in Customer',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        'Guest',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: kGreyTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: customer.length,
                              itemBuilder: (_, index) {
                                customer[index].type == 'Retailer' ? color = const Color(0xFF56da87) : Colors.white;
                                customer[index].type == 'Wholesaler' ? color = const Color(0xFF25a9e0) : Colors.white;
                                customer[index].type == 'Dealer' ? color = const Color(0xFFff5f00) : Colors.white;
                                customer[index].type == 'Supplier' ? color = const Color(0xFFA569BD) : Colors.white;
                                return customer[index].customerName.contains(searchCustomer) && !customer[index].type.contains('Supplier')
                                    ? GestureDetector(
                                        onTap: () {
                                          AddSalesScreen(customerModel: customer[index]).launch(context);
                                          cart.clearCart();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 50.0,
                                                width: 50.0,
                                                child:CircleAvatar(
                                                  foregroundColor: Colors.blue,
                                                  backgroundColor: kMainColor,
                                                  radius: 70.0,
                                                  child: Text(customer[index].customerName.isNotEmpty ? customer[index].customerName.substring(0,1) : '',style: TextStyle(color: Colors.white),),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    customer[index].customerName.isNotEmpty ? customer[index].customerName : customer[index].phoneNumber,
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    customer[index].type,
                                                    style: GoogleFonts.poppins(
                                                      color: color,
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
                                                    '$currency ${customer[index].dueAmount}',
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
                                              ).visible(customer[index].dueAmount != '' && customer[index].dueAmount != '0'),
                                              const SizedBox(width: 20),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                color: kGreyTextColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              }),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          CustomerModel guestModel = CustomerModel(
                            'Guest',
                            'Guest',
                            'Guest',
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                            'Guest',
                            'Guest',
                            '0',
                            '0',
                            '',
                          );
                          AddSalesScreen(customerModel: guestModel).launch(context);
                          cart.clearCart();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: CircleAvatar(
                                  foregroundColor: Colors.blue,
                                  backgroundColor: kMainColor,
                                  radius: 70.0,
                                  child: Text('G',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Walk-in Customer',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    'Guest',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(width: 20),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: kGreyTextColor,
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              const AddCustomer().launch(context);
            }),
      );
    });
  }
}
