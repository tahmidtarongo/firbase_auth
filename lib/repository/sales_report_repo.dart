import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Screens/Sales/Model/sales_report.dart';

class SalesReportRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<List<SalesReport>> getAllSalesReport() async {
    List<SalesReport> salesReportList = [];
    await FirebaseDatabase.instance.ref(userId).child('Sales Report').orderByKey().get().then((value) {
      for (var element in value.children) {
        salesReportList.add(SalesReport.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final salesReportRef = FirebaseDatabase.instance.ref(userId).child('Sales Report');
    salesReportRef.keepSynced(true);
    return salesReportList;
  }
}
