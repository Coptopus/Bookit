import 'package:bookit/model/booking.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Booking> _bookings = [];
  double _oldPrice = 0.0;
  double _price = 0.0;
  bool redeemed = false;
  int pointsRedeemed = 0;
  
  void add(Booking booking) {
    if (redeemed) {
      revert();
    }
    _bookings.add(booking);
    _price += booking.price;
    notifyListeners();
  }

  void remove(Booking booking) {
    if (redeemed) {
      revert();
    }
    _bookings.remove(booking);
    _price -= booking.price;
    notifyListeners();
  }

  void redeem(x , y){
    _oldPrice = _price;
    _price = _price*x;
    pointsRedeemed = y;
    redeemed = true;
    notifyListeners();
  }

  void revert(){
    _price = _oldPrice;
    _oldPrice = 0.0;
    pointsRedeemed = 0;
    redeemed = false;
    notifyListeners();
  }

  void reset(){
    _bookings.clear();
    _price = 0.0;
    _oldPrice = 0.0;
    pointsRedeemed = 0;
    redeemed = false;
  }

  int get count {
    return _bookings.length;
  }

  double get totalPrice {
    return _price;
  }

  double get oldPrice {
    return _oldPrice;
  }

  List<Booking> get cartItems {
    return _bookings;
  }
}
