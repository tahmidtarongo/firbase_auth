import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/student.dart';

Future<List<StudentModel>> getStudent() async {
  List<StudentModel> allStudent = [];
  CollectionReference students = FirebaseFirestore.instance.collection('students');

  final QuerySnapshot data = await students.get();

  for (var element in data.docs) {
    Map<String, dynamic> student = element.data() as Map<String, dynamic>;
    allStudent.add(StudentModel.fromJson(json: student));
  }

  return allStudent;
}
