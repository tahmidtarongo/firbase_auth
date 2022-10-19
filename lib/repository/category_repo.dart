import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';

class CategoryRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<CategoryModel>> getAllCategory() async {
    List<CategoryModel> categoryList = [];
    await FirebaseDatabase.instance.ref(userId).child('Categories').orderByKey().get().then((value) {
      for (var element in value.children) {
        categoryList.add(CategoryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return categoryList;
  }
}
