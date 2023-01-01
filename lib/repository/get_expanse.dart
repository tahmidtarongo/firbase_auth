import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/expense_model.dart';

class ExpenseRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<List<ExpenseModel>> getAllExpense() async {
    List<ExpenseModel> allExpense = [];

    await FirebaseDatabase.instance.ref(userId).child('Expense').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpense.add(data);
      }
    });
    return allExpense;
  }
}
