// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_pos/Screen/Home/home_screen.dart';

class EditStudentScreen extends StatefulWidget {
  const EditStudentScreen({Key? key, required this.studentModel}) : super(key: key);

  final StudentModel studentModel;

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  Future<void> editData({required StudentModel studentModel}) async {
    DocumentReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc(widget.studentModel.id);

    students.update(studentModel.toJson());

    EasyLoading.show(status: 'Loading...');

    EasyLoading.showSuccess('Edit Done');
  }



  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.studentModel.name ?? '';
    classController.text = widget.studentModel.studentClass.toString();
    rollController.text = widget.studentModel.roll.toString();
    sectionController.text = widget.studentModel.section ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    classController.dispose();
    rollController.dispose();
    sectionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
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
                StudentModel data = StudentModel(
                    name: nameController.text,
                    studentClass: int.tryParse(classController.text) ?? 0,
                    roll: int.tryParse(rollController.text) ?? 0,
                    section: sectionController.text);

                editData(studentModel: data);
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
              child: const Text('Save'),
            ),
          ],
        )),
      ),
    );
  }
}
