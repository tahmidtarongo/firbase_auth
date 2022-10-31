import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/product_model.dart';

class ProductRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  Future<List<ProductModel>> getAllProduct() async {
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance.ref(userId).child('Products').orderByKey().get().then((value) {
      for (var element in value.children) {
        productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    return productList;
  }
}
