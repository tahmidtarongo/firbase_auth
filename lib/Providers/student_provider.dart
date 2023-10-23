import 'package:flutter/cupertino.dart';

import '../Models/student.dart';
import '../Repo/student_get_repo.dart';

class StudentProvider extends ChangeNotifier {
  List<StudentModel> students = [];
  bool isLoading = false;

  Future<void> getStudents() async {
    isLoading = true;
    students = await getStudentRepo();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateData() async {
    students = await getStudentRepo();
    notifyListeners();
  }
}
