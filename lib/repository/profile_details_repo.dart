import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/personal_information_model.dart';

class ProfileRepo {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<PersonalInformationModel> getDetails() async {
    PersonalInformationModel personalInfo = PersonalInformationModel(
        companyName: 'Loading...',
        businessCategory: 'Loading...',
        countryName: 'Loading...',
        language: 'Loading...',
        phoneNumber: 'Loading...',
        pictureUrl: 'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png');
    final userRef = FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
    userRef.keepSynced(true);
    final model = await userRef.get();
    var data = jsonDecode(jsonEncode(model.value));
    if (data == null) {
      return personalInfo;
    } else {
      return PersonalInformationModel.fromJson(data);
    }
  }
}
