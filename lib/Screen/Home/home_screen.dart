// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';

import '../../Repo/student_get_repo.dart';
import '../Auth/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> postData({required StudentModel studentModel}) async {
    CollectionReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '');
    EasyLoading.show(status: 'Loading...');
    await students.add(studentModel.toJson());

    EasyLoading.showSuccess('Data Post Done');
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController sectionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ElevatedButton(onPressed: logOut, child: const Text("Log Out")),
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to Home Screen ${FirebaseAuth.instance.currentUser?.email}'),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: classController,
                decoration: const InputDecoration(
                  labelText: 'Class',
                  hintText: 'Enter Your Class',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: rollController,
                decoration: const InputDecoration(
                  labelText: 'Roll',
                  hintText: 'Enter Your Roll Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
              child: TextFormField(
                controller: sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  hintText: 'Enter Your Section',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                StudentModel data =
                    StudentModel(name: nameController.text, studentClass: int.parse(classController.text), roll: int.parse(rollController.text), section: sectionController.text);

                postData(studentModel: data);
                nameController.clear();
                classController.clear();
                rollController.clear();
                sectionController.clear();
              },
              child: const Text('Save This Student'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text('Reload'),
            ),
            FutureBuilder<List<StudentModel>>(
              future: getStudent(),
              builder: (BuildContext context, studentData) {
                if (studentData.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
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
                            trailing: Text(singleStudent?.section ?? ''),
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
