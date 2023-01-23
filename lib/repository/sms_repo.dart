

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/payment_verification_model.dart';
import 'package:mobile_pos/model/sms_model.dart';

class SmsRepo{
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<List<SmsModel>> getAllSms() async {
    List<SmsModel> historyList = [];
    await FirebaseDatabase.instance.ref('Admin Panel').child('Sms List').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = SmsModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if(data.sellerId == userId){
          historyList.add(data);
        }
      }
    });

    return historyList;
  }

  Future<List<PaymentVerificationModel>> getAllTransaction() async {
    List<PaymentVerificationModel> historyList = [];
    await FirebaseDatabase.instance.ref('Admin Panel').child('Payment Verification').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = PaymentVerificationModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if(data.sellerID == userId){
          historyList.add(data);
        }
      }
    });
    return historyList;
  }
}
