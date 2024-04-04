import 'package:intl/intl.dart';

final NumberFormat money = NumberFormat.currency(symbol: "E\u00a3", name: "EGP",);
final DateFormat fdate = DateFormat('E, d/M/y, h:mm a');
final DateFormat ftime = DateFormat.jm();