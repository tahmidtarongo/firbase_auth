// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';

import 'Auth/sign_in_screen.dart';
import 'Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextPage();
  }

  void nextPage() async {
    await Future.delayed(const Duration(seconds: 3));

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: const Center(
        child: Text('Splash Screen', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
