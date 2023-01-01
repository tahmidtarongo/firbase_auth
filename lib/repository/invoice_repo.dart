import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/invoice_model.dart';

class InvoiceRepo{

  static Future<InvoiceModel> getInvoiceSettings() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('$userId/Invoice Settings');
    ref.keepSynced(true);
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    return InvoiceModel.fromJson(data);
  }

}