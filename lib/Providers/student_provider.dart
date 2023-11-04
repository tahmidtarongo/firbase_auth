import 'package:flutter/cupertino.dart';

import '../Models/student.dart';
import '../Repo/student_get_repo.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profile = ProfileModel();
  bool isLoading = false;

  Future<void> getProfile() async {
    print('Get profile');
    isLoading = true;
    profile = await getProfileRepo();
    isLoading = false;
    notifyListeners();
  }
  //
  // Future<void> updateData() async {
  //   profile = await getStudentRepo();
  //   notifyListeners();
  // }
}
