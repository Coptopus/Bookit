import 'package:bookit/model/booking.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Booking> _bookings = [];
  double _price = 0.0;
  
  void add(Booking booking) {
    _bookings.add(booking);
    _price += booking.price;
    notifyListeners();
  }

  void remove(Booking booking) {
    _bookings.remove(booking);
    _price -= booking.price;
    notifyListeners();
  }

  void reset(){
    _bookings.clear();
    _price = 0.0;
  }

  int get count {
    return _bookings.length;
  }

  double get totalPrice {
    return _price;
  }

  List<Booking> get cartItems {
    return _bookings;
  }
}
