import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/subscription_model.dart';
import 'package:mobile_pos/subscription.dart';

class SubscriptionRepo {
  static Future<SubscriptionModel> getSubscriptionData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('$userId/Subscription');
    ref.keepSynced(true);
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    Subscription.selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    return SubscriptionModel.fromJson(data);
  }
}
