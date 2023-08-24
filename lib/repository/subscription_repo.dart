import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/subscription_model.dart';
import 'package:mobile_pos/subscription.dart';

import '../currency.dart';

class SubscriptionRepo {
  static Future<SubscriptionModel> getSubscriptionData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    ref.keepSynced(true);
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    Subscription.selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    return SubscriptionModel.fromJson(data);
  }
}
