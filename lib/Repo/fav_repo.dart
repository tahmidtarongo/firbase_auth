import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/product_model.dart';

Future<List<ProductModel>> getFavProducts() async {
  List<ProductModel> favList = [];
  CollectionReference product = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('products').collection('products');

  final QuerySnapshot data = await product.get();
  for (var element in data.docs) {
    ProductModel data2 = ProductModel.fromJson(json: element.data() as Map<String, dynamic>);
    if (data2.isFev) {
      data2.databaseKey = element.id;
      favList.add(data2);
    }
  }

  return favList;
}
