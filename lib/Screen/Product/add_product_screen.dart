// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/Models/product_model.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_pos/Providers/student_provider.dart';
import 'package:mobile_pos/Screen/Home/home.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Future<String> imageUpload({required String path}) async {
    Reference ref = FirebaseStorage.instance.ref().child('Product_Image/${DateTime.now().toString()}');

    var stringPath = await ref.putFile(File(path));
    return stringPath.ref.getDownloadURL();
  }

  Future<void> addProductData({required ProductModel productData}) async {
    CollectionReference product = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('products').collection('products');

    await product.add(productData.toJson());
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  ImagePicker picker = ImagePicker();

  String? imagePath;

  bool isAdmin = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product'), backgroundColor: Colors.blue),
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter Your Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  controller: salePriceController,
                  decoration: const InputDecoration(
                    labelText: 'Sale Price',
                    hintText: 'Enter Your Sale price',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  controller: purchasePriceController,
                  decoration: const InputDecoration(
                    labelText: 'Purchase Price',
                    hintText: 'Enter Your Purchase Price',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                child: TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Enter Product Stock',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () async {
                    var i = await picker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      imagePath = i?.path ?? '';
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: imagePath == null ? Image.asset('images/image_1.png') : Image.file(File(imagePath ?? ''), fit: BoxFit.cover),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  imagePath != null ? imagePath = await imageUpload(path: imagePath ?? '') : null;
                  ProductModel product = ProductModel(
                    productId: Timestamp.now().millisecondsSinceEpoch,
                    productName: nameController.text,
                    salePrice: double.tryParse(salePriceController.text) ?? 0,
                    purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
                    productStock: int.tryParse(stockController.text) ?? 0,
                    productImage: imagePath ?? '',
                    isFev: false,
                  );

                  // ProfileModel data = ProfileModel(
                  //     name: nameController.text, address: salePriceController.text, phoneNumber: purchasePriceController.text, landMark: stockController.text, isAdmin: isAdmin);

                  await addProductData(productData: product);
                  nameController.clear();
                  salePriceController.clear();
                  purchasePriceController.clear();
                  stockController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text('Save product'),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
