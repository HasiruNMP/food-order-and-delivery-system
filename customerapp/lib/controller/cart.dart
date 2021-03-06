
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'item.dart';

class Cart extends ChangeNotifier {
  //Item(id: 15, name: "Cheese Burger", price: 450.0, imgUrl: "", quantity: 1),
  // Item(id: 16, name: "Pizza", price: 950.0, imgUrl: "", quantity: 1)
  static List<Item> _items = [];
  static int noificationCount = 0;
  static void EmptyCart() {
    _items.removeRange(0, _items.length);
  }

  static double _totalPrice = 0.00;
  void add(Item item) {
    int index = _items.indexWhere((i) => i.name == item.name);
    print('indexxxx $index');
    if (index == -1) {
      _items.add(item);
      _totalPrice += item.price * item.quantity;
      notifyListeners();
      print('item Added!');
      const AdvanceSnackBar(message: "Hello...").show;
      // Get.snackbar(
      //     "Product Added", "You have added the ${item.name} to the cart",
      //     snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
    } else {
      const AdvanceSnackBar(message: "Hello...").show;
      print('Already Added');
      // Get.snackbar("Already Added ",
      //     "You have added the ${item.name} to the cart already",
      //     snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 1));
    }
  }

  static void NotificationLength(int value) {
    noificationCount = value;
  }

  static int get NotifyCount {
    return noificationCount;
  }

  // void removeWithprice(Item item) {
  //   _totalPrice = 0.0;
  //   _items.remove(item);
  //   notifyListeners();
  // }

  void remove(Item item) {
    _totalPrice -= item.price * item.quantity;
    _items.remove(item);
    notifyListeners();
  }

  void calculateTotal() {
    _totalPrice = 0;
    _items.forEach((f) {
      _totalPrice += f.price * f.quantity;
    });
    notifyListeners();
  }

  void updateProduct(item, quantity) {
    int index = _items.indexWhere((i) => i.name == item.name);
    _items[index].quantity = quantity;
    if (_items[index].quantity == 0) remove(item);

    calculateTotal();
    notifyListeners();
  }

  static int get count {
    return _items.length;
  }

  static double get totalPrice {
    return _totalPrice;
  }

  static List<Item> get basketItems {
    return _items;
  }

  static void PaymentStates() {
    // Get.snackbar("Order Completed Successfully!", "Thank You!",
    //     snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
  }
}
