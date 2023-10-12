// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Screen/Auth/phone_auth.dart';
import 'package:mobile_pos/Screen/Auth/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              'Log In',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Please enter your email.',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Please enter your password.',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (emailController.text != '' && passwordController.text != '') {
                    if (emailController.text.contains('@') && emailController.text.contains('.com')) {
                      try {
                        var auth = FirebaseAuth.instance;

                        UserCredential user = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                        if (user.user != null) {
                          EasyLoading.showSuccess('Successfully Login');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        } else {
                          EasyLoading.showError('Something is wrong');
                        }
                      } on FirebaseAuthException catch (e) {
                        EasyLoading.showError(e.code);
                      } catch (e) {
                        EasyLoading.showError(e.toString());
                      }
                    }
                  } else {
                    EasyLoading.showError('Enter email & password');
                  }
                },
                child: const Text('LogIn')),
            TextButton(
                onPressed: () {
                  // _handleSignIn();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ));
                },
                child: const Text('Sign Up')),
            TextButton(
                onPressed: () {
                  // _handleSignIn();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneAuthScreen(),
                      ));
                },
                child: const Text('Sign Up with Phone')),
            TextButton(
                onPressed: () async {
                  UserCredential user = await signInWithGoogle();
                  if (user.user != null) {
                    EasyLoading.showSuccess('Done');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  } else {
                    EasyLoading.showError('Something is Wrong');
                  }
                },
                child: const Text('SignIn with Google')),
          ],
        ),
      ),
    );
  }
}
