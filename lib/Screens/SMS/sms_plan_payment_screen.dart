import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/model/payment_verification_model.dart';
import 'package:mobile_pos/model/sms_subscription_plan_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import 'message_history.dart';

class SmsPlanPaymentScreen extends StatefulWidget {
  const SmsPlanPaymentScreen({Key? key, required this.model}) : super(key: key);

  final SmsSubscriptionPlanModel model;

  @override
  State<SmsPlanPaymentScreen> createState() => _SmsPlanPaymentScreenState();
}

class _SmsPlanPaymentScreenState extends State<SmsPlanPaymentScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final userProfileDetails = ref.watch(profileDetailsProvider);
      return userProfileDetails.when(data: (user) {
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            title: ListTile(
              onTap: () => const MessageHistory().launch(context),
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Complete Transaction',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                'Sms left: ${user.smsBalance}',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.0),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  Text(
                    'History',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0.0,
          ),
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Instructions:',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    '1) Go to your Bkash mobile menu by dialing *247# or open Bkash App',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    '2) Choose Option "Payment"',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    '3) Enter Merchant Account Number: 01712022529',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    '4) Enter Amount of BDT ${widget.model.smsPackOfferPrice}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    '5) Enter Counter Number 1',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    '6) Enter your Bkash menu pin to confirm the transaction',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const Text(
                    '7) Copy the transaction id',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Payee Name',
                      hintText: 'Enter Your Name.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Payee Number',
                      hintText: 'Enter Your mobile number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: transactionIdController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Transaction Id',
                      hintText: 'Enter Your Transaction Id',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ButtonGlobalWithoutIcon(
                    buttontext: 'Submit',
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () async{
                      EasyLoading.show(status: 'Loading');
                      PaymentVerificationModel payment = PaymentVerificationModel(sellerName: user.companyName.toString(), sellerPhone: user.phoneNumber.toString(), sellerID: FirebaseAuth.instance.currentUser!.uid, shopName: user.companyName.toString(), paymentPhoneNumber: phoneNumberController.text, transactionId: transactionIdController.text, paymentRef: 'SMS Plan', paidAmount: widget.model.smsPackOfferPrice, verificationStatus: 'pending', verificationAttemptsDate: DateTime.now().toString(), smsSubscriptionPlanModel: widget.model,);
                      final dbRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Payment Verification');
                      await dbRef.push().set(payment.toJson());
                      EasyLoading.showSuccess('Successful');
                    },
                    buttonTextColor: Colors.white,
                  ),
                ],
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
