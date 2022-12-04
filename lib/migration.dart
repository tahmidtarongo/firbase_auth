import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MigrationFirebase {
  Future<bool> migrateUsers() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    final database = FirebaseDatabase.instance.ref(userId).child("Customers");
    database.keepSynced(true);
    database.orderByKey().get().then((value) {
     for(var element in value.children){
       database.child(element.key.toString()).update({"migrated" : true});
     }
    });
    return true;
  }
}
