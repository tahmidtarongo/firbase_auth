// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Auth/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();

    EasyLoading.showSuccess('LogOut Done');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ));
  }

  CollectionReference u = FirebaseFirestore.instance.collection('users');

  Future<void> postData({required String name}) async {
    EasyLoading.show(status: 'Loading...');
    await u.add({
      'name': name,
    });

    EasyLoading.showSuccess('Data Post Done');
  }

  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ElevatedButton(onPressed: logOut, child: const Text("Log Out")),
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to Home Screen ${FirebaseAuth.instance.currentUser?.email}'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                postData(name: nameController.text);
                nameController.clear();
              },
              child: const Text('Post Data'),
            ),
            FutureBuilder<QuerySnapshot>(
              future: u.get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> name = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                        return Text("UserName = ${name['name']}");
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
