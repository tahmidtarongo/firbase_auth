// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
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
      appBar: AppBar(title: const Text('Add Student')),
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                Navigator.pop(context);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
              },
              child: const Text('Save This Student'),
            ),
          ],
        )),
      ),
    );
  }
}
