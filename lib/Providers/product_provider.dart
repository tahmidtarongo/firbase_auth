import 'package:flutter/cupertino.dart';
import 'package:mobile_pos/Repo/product_get_repo.dart';

import '../Models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ProductModel> products = [];
  List<ProductModel> favProducts = [];

  getFavProducts() {
    favProducts.clear();
    for (var element in products) {
      if (element.isFev) {
        favProducts.add(element);
      }
    }
  }

  Future<void> getProductsFromFirebase() async {
    isLoading = true;

    products = await getProduct();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProducts() async {
    products = await getProduct();
    getFavProducts();
    notifyListeners();
  }
}
