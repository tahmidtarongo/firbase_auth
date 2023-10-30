import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/student.dart';

Future<ProfileModel> getProfileRepo() async {
  DocumentReference profile = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser?.uid ?? '').doc('profile');

  final DocumentSnapshot data = await profile.get();
  ProfileModel p = ProfileModel.fromJson(json: data.data() as Map<String, dynamic>);

  return p;
}
