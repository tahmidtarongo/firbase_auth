// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Auth/sign_in_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: logOut, child: const Text("Log Out")),
            const Text('Welcome to Home Screen'),
          ],
        )),
      ),
    );
  }
}
