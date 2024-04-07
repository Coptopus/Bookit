class Booking {
  String serviceID;
  String providerID;
  DateTime start;
  int duration;
  DateTime end;
  double price;
  Booking(
      {required this.serviceID,
      required this.providerID,
      required this.start,
      required this.duration,
      required this.end,
      required this.price,
      });
}
