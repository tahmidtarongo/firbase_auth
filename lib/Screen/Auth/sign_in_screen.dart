// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Screen/Auth/phone_auth.dart';
import 'package:mobile_pos/Screen/Auth/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/home.dart';
import '../Home/home_screen.dart';
import '../Profile/new_profile_setup.dart';

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

  Future<void> setRememberMe({required String email, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('user_pass', password);
  }

  getRememberData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = prefs.getBool('isRememberMe') ?? false;

      if (rememberMe) {
        emailController.text = prefs.getString('user_email') ?? '';
        passwordController.text = prefs.getString('user_pass') ?? '';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRememberData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool rememberMe = false;

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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: rememberMe,
                      onChanged: (value) async {
                        setState(() {
                          rememberMe = value;
                        });

                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isRememberMe', value);
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController forgotEmailController = TextEditingController();
                          return Dialog(
                              child: Container(
                            width: 300,
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                                    controller: forgotEmailController,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotEmailController.text);
                                      EasyLoading.showSuccess('Please Check Your Email');
                                    },
                                    child: const Text(
                                      'Sent Mail',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                      );
                    },
                    child: const Text('Forgot Password')),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  if (emailController.text != '' && passwordController.text != '') {
                    if (emailController.text.contains('@') && emailController.text.contains('.com')) {
                      try {
                        var auth = FirebaseAuth.instance;

                        UserCredential user = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                        if (user.user != null) {
                          if (rememberMe) {
                            await setRememberMe(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }

                          EasyLoading.showSuccess('Successfully Login');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
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
                          builder: (context) => const Home(),
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
