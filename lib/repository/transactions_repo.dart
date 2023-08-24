import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/model/transition_model.dart';

import '../currency.dart';
import '../model/due_transaction_model.dart';

class TransitionRepo {
  Future<List<TransitionModel>> getAllTransition() async {
    List<TransitionModel> transitionList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Sales Transition').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(TransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });

    final transitionRef = FirebaseDatabase.instance.ref(constUserId).child('Sales Transition');
    transitionRef.keepSynced(true);
    return transitionList;
  }
}

class PurchaseTransitionRepo {
  Future<List<dynamic>> getAllTransition() async {
    List<dynamic> transitionList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Purchase Transition').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(PurchaseTransitionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final purchaseTransitionRef = FirebaseDatabase.instance.ref(constUserId).child('Sales Transition');
    purchaseTransitionRef.keepSynced(true);
    return transitionList;
  }
}

class DueTransitionRepo {
  Future<List<DueTransactionModel>> getAllTransition() async {
    List<DueTransactionModel> transitionList = [];
    await FirebaseDatabase.instance.ref(constUserId).child('Due Transaction').orderByKey().get().then((value) {
      for (var element in value.children) {
        transitionList.add(DueTransactionModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final dueTransitionRef = FirebaseDatabase.instance.ref(constUserId).child('Sales Transition');
    dueTransitionRef.keepSynced(true);
    return transitionList;
  }
}
