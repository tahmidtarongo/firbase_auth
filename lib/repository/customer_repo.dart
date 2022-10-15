import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';

class CustomerRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<CustomerModel>> getAllCustomers() async {
    List<CustomerModel> customerList = [];
    await FirebaseDatabase.instance.ref(userId).child('Customers').orderByKey().get().then((value) {
      for (var element in value.children) {
        customerList.add(CustomerModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return customerList;
  }
}
