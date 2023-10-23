import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/student.dart';

Future<List<StudentModel>> getStudentRepo() async {
  List<StudentModel> allStudent = [];
  CollectionReference students = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '');

  final QuerySnapshot data = await students.orderBy('class', descending: false).get();
  for (int i = 0; i < data.docs.length; i++) {
    Map<String, dynamic> student = data.docs[i].data() as Map<String, dynamic>;
    StudentModel s = StudentModel.fromJson(json: student);
    s.id = data.docs[i].id;
    allStudent.add(s);
  }

  return allStudent;
}
