// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';

import '../Screens/Products/Model/brands_model.dart';
import '../Screens/Products/Model/unit_model.dart';

class CategoryRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<CategoryModel>> getAllCategory() async {
    List<CategoryModel> categoryList = [];
    await FirebaseDatabase.instance.ref(userId).child('Categories').orderByKey().get().then((value) {
      for (var element in value.children) {
        categoryList.add(CategoryModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final categoryRef = FirebaseDatabase.instance.ref(userId).child('Categories');
    categoryRef.keepSynced(true);
    return categoryList;
  }
}

class BrandsRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<BrandsModel>> getAllBrand() async {
    List<BrandsModel> brandsList = [];
    await FirebaseDatabase.instance.ref(userId).child('Brands').orderByKey().get().then((value) {
      for (var element in value.children) {
        brandsList.add(BrandsModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final brandRef = FirebaseDatabase.instance.ref(userId).child('Brands');
    brandRef.keepSynced(true);
    return brandsList;
  }
}

class UnitsRepo {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<UnitModel>> getAllUnits() async {
    List<UnitModel> unitsList = [];
    await FirebaseDatabase.instance.ref(userId).child('Units').orderByKey().get().then((value) {
      for (var element in value.children) {
        unitsList.add(UnitModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
    final unitRef = FirebaseDatabase.instance.ref(userId).child('Units');
    unitRef.keepSynced(true);
    return unitsList;
  }
}
