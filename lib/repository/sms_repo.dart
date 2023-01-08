

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    historyList.addAll(historyList.reversed);
    return historyList;
  }
  
}
