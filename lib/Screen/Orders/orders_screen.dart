import 'package:flutter/material.dart';
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);



  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Order List'),
      ),
      body: const Column(children: [],),
    );
  }
}
