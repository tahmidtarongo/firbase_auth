// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:mobile_pos/Providers/student_provider.dart';
import 'package:mobile_pos/Screen/add_student_screen.dart';
import 'package:provider/provider.dart';

import '../../Repo/student_get_repo.dart';
import '../Auth/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../edit_student_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> deleteStudent({required ProfileModel studentModel}) async {
    DocumentReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc(studentModel.id);

    await students.delete();
    // Provider.of<profileProvider>(context, listen: false).updateData();
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<profileProvider>(context, listen: false).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const AddStudentScreen(),
      //           ));
      //     },
      //     child: const Icon(Icons.add)),
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Welcome to Home Screen ${FirebaseAuth.instance.currentUser?.email}'),
              ),
              // Consumer<profileProvider>(
              //   builder: (context, value, child) {
              //     return Padding(
              //       padding: const EdgeInsets.all(20),
              //       child: value.isLoading
              //           ? const Center(child: CircularProgressIndicator())
              //           : ListView.builder(
              //               shrinkWrap: true,
              //               physics: const NeverScrollableScrollPhysics(),
              //               itemCount: value.profile.length,
              //               itemBuilder: (context, index) {
              //                 ProfileModel? singleStudent = value.profile[index];
              //                 return Card(
              //                   child: ListTile(
              //                     title: Text('Name: ${singleStudent.name}'),
              //                     subtitle: Text('Class: ${singleStudent.address}'),
              //                     leading: Text(singleStudent.phoneNumber.toString() ?? '0'),
              //                     trailing: Row(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         GestureDetector(
              //                             onTap: () async {
              //                               await deleteStudent(studentModel: singleStudent);
              //                             },
              //                             child: const Icon(
              //                               Icons.delete,
              //                               color: Colors.red,
              //                             )),
              //                         const SizedBox(width: 5),
              //                         // GestureDetector(
              //                         //     onTap: () {
              //                         //       Navigator.push(
              //                         //         context,
              //                         //         MaterialPageRoute(
              //                         //           builder: (context) => EditStudentScreen(studentModel: singleStudent!),
              //                         //         ),
              //                         //       );
              //                         //     },
              //                         //     child: const Icon(
              //                         //       Icons.edit,
              //                         //     )),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //             ),
              //     );
              //   },
              // ),
            ],
          ),
        )),
      ),
    );
  }
}
