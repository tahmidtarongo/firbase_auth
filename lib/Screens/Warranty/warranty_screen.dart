import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({Key? key}) : super(key: key);

  @override
  State<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends State<WarrantyScreen> {
  String searchCustomer = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: const Text(
          'Sales List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: AppTextField(
                textFieldType: TextFieldType.NAME,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: kGreyTextColor.withOpacity(0.5),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchCustomer = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
