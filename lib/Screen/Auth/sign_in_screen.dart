
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Screen/Auth/phone_auth.dart';
import 'package:mobile_pos/Screen/Auth/sign_up_screen.dart';

import '../Home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);


  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<User?> _handleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       final UserCredential authResult = await _auth.signInWithCredential(credential);
  //       final User? user = authResult.user;
  //
  //       if (user != null) {
  //         // Successful sign-in with Gmail, you can navigate to the next screen or perform other actions.
  //         return user;
  //       } else {
  //         // Handle sign-in failure
  //         return null;
  //       }
  //     } else {
  //       // Handle Google sign-in cancellation
  //       return null;
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     return null;
  //   }
  // }

  // Future<void> verifyPhoneNumber() async {
  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumberController.text,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         // Automatically sign in the user when OTP is received.
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         // Handle verification failed
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         // Store the verification ID to be used later
  //         this.verificationId = verificationId;
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // Auto-retrieval timeout, if needed
  //       },
  //       timeout: const Duration(seconds: 60),
  //     );
  //   } catch (e) {
  //     // Handle exceptions
  //   }
  // }
  //
  // void verifyPhoneNumber() {
  //   FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: "01631865339",
  //     verificationCompleted: (phoneAuthCredential) {},
  //     verificationFailed: (error) {},
  //     codeSent: (verificationId, forceResendingToken) {},
  //     codeAutoRetrievalTimeout: (verificationId) {},
  //   );
  // }
  // Future<void> signInWithOTP({required String verificationId,required String otpController}) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: otpController,
  //     );
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     // Handle exceptions
  //   }
  // }

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
        padding: EdgeInsets.all(30),
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
          ],
        ),
      ),
    );
  }
}
