// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/cart_model.dart';
import 'package:mobile_pos/Models/product_model.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:mobile_pos/Providers/cart_provider.dart';
import 'package:mobile_pos/Providers/product_provider.dart';
import 'package:mobile_pos/Providers/student_provider.dart';
import 'package:mobile_pos/Screen/add_student_screen.dart';
import 'package:provider/provider.dart';

import '../../Repo/student_get_repo.dart';
import '../Auth/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../edit_student_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> deleteStudent({required ProfileModel studentModel}) async {
    DocumentReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc(studentModel.id);

    await students.delete();
    // Provider.of<profileProvider>(context, listen: false).updateData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> addFev({required ProductModel product, required bool value}) async {
    DocumentReference p = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('products').collection('products').doc(product.databaseKey);

    await p.update({
      'isFev': value,
    });
    Provider.of<ProductProvider>(context, listen: false).updateProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),

      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const AddStudentScreen(),
      //           ));
      //     },
      //     child: const Icon(Icons.add)),
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Welcome to Home Screen ${FirebaseAuth.instance.currentUser?.email}'),
              ),
              Consumer<ProductProvider>(builder: (context, value, child) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
                  itemCount: value.products.length,
                  itemBuilder: (context, index) {
                    bool fev = value.products[index].isFev;
                    return SizedBox(
                      width: 200,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              width: 200,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                image: DecorationImage(
                                  image: NetworkImage(value.products[index].productImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.heart_broken,
                                    color: fev ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await addFev(product: value.products[index], value: !fev);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(value.products[index].productName),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Price: \$${value.products[index].salePrice}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Stock: \$${value.products[index].productStock}'),
                                  IconButton(
                                      onPressed: () {
                                        CartModel cart = CartModel(
                                            productId: value.products[index].productId,
                                            productName: value.products[index].productName,
                                            salePrice: value.products[index].salePrice,
                                            purchasePrice: value.products[index].purchasePrice,
                                            productStock: value.products[index].productStock,
                                            productImage: value.products[index].productImage,
                                            isFev: value.products[index].isFev,
                                            quantity: 1);
                                        Provider.of<CartProvider>(context, listen: false).addToCart(cartModel: cart);
                                      },
                                      icon: const Icon(Icons.add_shopping_cart))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        )),
      ),
    );
  }
}
