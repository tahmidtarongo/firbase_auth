import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Models/product_model.dart';

import '../Models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];
  double subtotal = 0;

  calculateSubtotal() {
    subtotal = 0;
    for (var element in cartList) {
      subtotal += (element.quantity * element.salePrice);
    }
    notifyListeners();
  }

  addToCart({required CartModel cartModel}) {
    if (cartList.isNotEmpty) {
      for (var element in cartList) {
        print(subtotal);
        if (element.productId == cartModel.productId) {
          element.quantity++;
          break;
        }

        if (element == cartList.last) {
          cartList.add(cartModel);
        }
      }
    } else {
      cartList.add(cartModel);
    }
    calculateSubtotal();
    notifyListeners();
  }

  removeFromCart({required CartModel cartModel}) {
    cartList.remove(cartModel);
    notifyListeners();
  }

  ///__________Add_quantity_______________________
  addQuantity({required int index}) {
    if (cartList[index].quantity < cartList[index].productStock) {
      cartList[index].quantity++;
    } else {
      EasyLoading.showError('Out Of Stock');
    }
    calculateSubtotal();
    notifyListeners();
  }

  subQuantity({required int index}) {
    if (cartList[index].quantity <= 1) {
      cartList.remove(cartList[index]);
    } else {
      cartList[index].quantity--;
    }
    calculateSubtotal();
    notifyListeners();
  }

  clearCart(){
    cartList.clear();
    calculateSubtotal();
    notifyListeners();
  }
}
