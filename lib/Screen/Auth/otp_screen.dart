// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Future<void> checkOtp({required String smsCode, required String id}) async {
    try {
      var auth = FirebaseAuth.instance;
      PhoneAuthCredential user = PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode);
      await auth.signInWithCredential(user);
      EasyLoading.showSuccess('Done');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  String otp = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Pinput(
                length: 6,
                onChanged: (v) {
                  otp = v;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    await checkOtp(id: widget.id, smsCode: otp);
                  },
                  child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
