// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:mobile_pos/Screen/add_student_screen.dart';

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
  Future<void> deleteStudent({required StudentModel studentModel}) async {
    DocumentReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc(studentModel.id);

    students.delete();

    EasyLoading.show(status: 'Loading...');

    EasyLoading.showSuccess('Delete Done');
    setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStudentScreen(),
                ));
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: ElevatedButton(onPressed: logOut, child: const Text("Log Out")),
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Welcome to Home Screen ${FirebaseAuth.instance.currentUser?.email}'),
            ),
            FutureBuilder<List<StudentModel>>(
              future: getStudent(),
              builder: (BuildContext context, studentData) {
                if (studentData.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: studentData.data?.length,
                      itemBuilder: (context, index) {
                        StudentModel? singleStudent = studentData.data?[index];
                        return Card(
                          child: ListTile(
                            title: Text('Name: ${singleStudent?.name}'),
                            subtitle: Text('Class: ${singleStudent?.studentClass}'),
                            leading: Text(singleStudent?.roll.toString() ?? '0'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      await deleteStudent(studentModel: singleStudent!);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                const SizedBox(width: 5),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStudentScreen(studentModel: singleStudent!),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                    )),
                              ],
                            ),
                          ),
                        );
                        return Text("Student Name : ${studentData.data?[index].name}");
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
