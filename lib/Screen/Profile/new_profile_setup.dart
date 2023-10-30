// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_pos/Providers/student_provider.dart';
import 'package:mobile_pos/Screen/Home/home.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';
import 'package:provider/provider.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  Future<void> postData({required ProfileModel studentModel}) async {
    DocumentReference user = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('profile');

    await user.set(studentModel.toJson());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );

    // Provider.of<StudentProvider>(context, listen: false).updateData();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController sectionController = TextEditingController();

  bool isAdmin = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Your Profile')),
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: classController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter Your address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: rollController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter Your phone number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: sectionController,
                decoration: const InputDecoration(
                  labelText: 'Landmark',
                  hintText: 'Enter Your Landmark',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Switch(
              value: isAdmin,
              onChanged: ((value) {
                setState(() {
                  isAdmin = value;
                });
              }),
            ),
            ElevatedButton(
              onPressed: () async {
                ProfileModel data =
                    ProfileModel(name: nameController.text, address: classController.text, phoneNumber: rollController.text, landMark: sectionController.text, isAdmin: isAdmin);

                await postData(studentModel: data);
                nameController.clear();
                classController.clear();
                rollController.clear();
                sectionController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        )),
      ),
    );
  }
}
