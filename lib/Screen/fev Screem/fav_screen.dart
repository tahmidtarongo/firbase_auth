import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/Providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../Models/product_model.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getFavProducts();
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
        title: const Text('Favorite'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ProductProvider>(builder: (context, value, child) {
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: value.favProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(value.favProducts[index].productName),
                    subtitle: Text(value.favProducts[index].salePrice.toString()),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await addFev(value: false, product: value.favProducts[index]);
                        }),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
