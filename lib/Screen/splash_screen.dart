// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import 'Auth/sign_in_screen.dart';

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

  void nextPage()async{
   await Future.delayed(const Duration(seconds: 3));
   Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),));
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
