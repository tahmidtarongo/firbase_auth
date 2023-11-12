import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_pos/Models/product_model.dart';

Future<List<ProductModel>> getProduct() async {
  List<ProductModel> products = [];
  CollectionReference product = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('products').collection('products');

  final QuerySnapshot data = await product.get();
  for (var element in data.docs) {
    ProductModel data2 = ProductModel.fromJson(json: element.data() as Map<String, dynamic>);
    data2.databaseKey = element.id;
    products.add(data2);
  }

  return products;
}
