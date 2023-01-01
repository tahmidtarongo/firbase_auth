import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/expense_category_model.dart';

class ExpenseCategoryRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<List<ExpenseCategoryModel>> getAllExpenseCategory() async {
    List<ExpenseCategoryModel> allExpenseCategoryList = [];

    await FirebaseDatabase.instance.ref(userId).child('Expense Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = ExpenseCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
        allExpenseCategoryList.add(data);
      }
    });
    return allExpenseCategoryList;
  }
}
//
// class IncomeCategoryRepo {
//   final userId = FirebaseAuth.instance.currentUser!.uid;
//   Future<List<IncomeCategoryModel>> getAllIncomeCategory() async {
//     List<IncomeCategoryModel> allIncomeCategoryList = [];
//
//     await FirebaseDatabase.instance.ref(userId).child('Income Category').orderByKey().get().then((value) {
//       for (var element in value.children) {
//         var data = IncomeCategoryModel.fromJson(jsonDecode(jsonEncode(element.value)));
//         allIncomeCategoryList.add(data);
//       }
//     });
//     return allIncomeCategoryList;
//   }
// }
