// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Profile/new_profile_setup.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up Here',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: signUpEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Please enter your email.',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: signUpPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Please enter your password.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (signUpEmailController.text != '' && signUpPasswordController.text != '') {
                    if (signUpEmailController.text.contains('@') && signUpEmailController.text.contains('.com')) {
                      try {
                        EasyLoading.show(status: 'Loading...');
                        var auth = FirebaseAuth.instance;

                        UserCredential user = await auth.createUserWithEmailAndPassword(email: signUpEmailController.text, password: signUpPasswordController.text);

                        if (user.user != null) {
                          EasyLoading.showSuccess('Successfully Done');
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ProfileSetup();
                            },
                          ));
                        } else {
                          EasyLoading.showError('Something is Wrong');
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          EasyLoading.showError('The password provided is too weak.');
                          // print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          EasyLoading.showError('The account already exists for that email.');
                          // print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    } else {
                      EasyLoading.showError('Enter a valid email');
                    }
                  } else {
                    EasyLoading.showError('Enter email & password');
                  }
                },
                child: const Text('Sign Up')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Log in')),
          ],
        ),
      ),
    );
  }
}
