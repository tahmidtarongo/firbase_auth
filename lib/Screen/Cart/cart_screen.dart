import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> postOrder() async {
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    await orders.add({
      'orderId': 52143,
      'price': 32476,
      'userId': 2764821,
      'productId': 023846,
      'orderDate': Timestamp.now(),
    });

    // await orders.add();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      bottomNavigationBar: Consumer<CartProvider>(builder: (context, value, child) {
        return Container(
          height: 60,
          color: Colors.grey,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'SubTotal: ${value.subtotal}',
                style: const TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await postOrder();
                    value.clearCart();

                    EasyLoading.showSuccess('Order Susses');
                  },
                  child: const Text('CheckOut')),
            ],
          )),
        );
      }),
      body: Consumer<CartProvider>(builder: (context, value, child) {
        return value.cartList.isEmpty
            ? const Center(child: Text('Cart is Empty'))
            : ListView.builder(
                itemCount: value.cartList.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Row(
                      children: [
                        Text(value.cartList[index].productName),
                        const SizedBox(width: 20),
                        Text(
                          '${value.cartList[index].quantity}X${value.cartList[index].salePrice}=${value.cartList[index].quantity * value.cartList[index].salePrice}',
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        value.removeFromCart(cartModel: value.cartList[index]);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              value.subQuantity(index: index);
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                              child: Center(
                                  child: Icon(
                                Icons.remove,
                                size: 15,
                              )),
                            )),
                        // IconButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),onPressed: () {}, icon: const Icon(Icons.remove)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(value.cartList[index].quantity.toString()),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            value.addQuantity(index: index);
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 15,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              );
      }),
    );
  }
}
