import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/components/drawer.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/model/booking.dart';
import 'package:bookit/model/forrmatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/cart.dart';

class Details extends StatefulWidget {
  final dynamic data;
  const Details({super.key, this.data});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour + 2, 0);
  int dur = 1;
  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      return;
    } //CANCEL

    TimeOfDay? time = await pickTime();
    if (time == null) {
      return;
    }

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => this.dateTime = dateTime);
  }

  bool read = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Counter(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        drawer: appDrawer(context),
        appBar: AppBar(
          title: appTitle,
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {},
        //   icon: const Icon(Icons.edit_calendar),
        //   label: const Text("Book it!",
        //       style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900)),
        //   backgroundColor: Colors.blue,
        //   foregroundColor: Colors.white,
        // ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('services')
              .doc(widget.data)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              DateTime dt =
                  (snapshot.data!['oneTimeDate'] as Timestamp).toDate();
              return ListView(
                children: [
                  SizedBox(
                    height: 400,
                    child: snapshot.data!["img"] != "none"
                        ? Image.network(
                            snapshot.data!["img"],
                            fit: BoxFit.cover,
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 300,
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[300]),
                            child: const Icon(
                              Icons.photo,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!["name"],
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot.data!["provider"])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                "Owner info\nName: ${snapshot.data!["name"]}\nEmail: ${snapshot.data!["email"]}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w900),
                              );
                            }
                            return const Text("loading...");
                          },
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                            ),
                            width: 500,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              snapshot.data!["desc"],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Location:",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${snapshot.data!["location"]}\n",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 80),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.teal[50],
                              border: Border.all(color: Colors.teal),
                              borderRadius: BorderRadius.circular(10)),
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data!["timed"]
                                  ? Text(
                                      "${money.format(double.parse(snapshot.data!["price"]))} / hour",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.teal),
                                    )
                                  : Text(
                                      money.format(double.parse(
                                          snapshot.data!["price"])),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.teal),
                                    ),
                              if (snapshot.data!['oneTime'])
                                Text(
                                  "Event Date\n ${fdate.format(dt)}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.lightBlue)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                !snapshot.data!['oneTime']
                                    ? "Pick a date and time:"
                                    : "Time and Date set by Owner:",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(5),
                                  color: Colors.lightBlue,
                                  disabledColor: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: !snapshot.data!['oneTime']
                                      ? () async {
                                          await pickDateTime();
                                        }
                                      : null,
                                  child: Consumer<Cart>(
                                    builder: (context, cart, child) {
                                      if (cart.cartItems.isNotEmpty && !read) {
                                        dateTime = cart.cartItems.last.end
                                            .add(const Duration(hours: 1));
                                        read = true;
                                      }
                                      if (snapshot.data!['oneTime']) {
                                        dateTime = dt;
                                        read = true;
                                      }
                                      return Text(fdate.format(dateTime),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25), textAlign: TextAlign.center,);
                                      // return Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceAround,
                                      //   children: [
                                      //     Text(
                                      //         "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                      // style: const TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 25)),
                                      //     Text("$hours:$minutes",
                                      //         style: const TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 25))
                                      //   ],
                                      // );
                                    },
                                  )),
                              if (snapshot.data!['timed'])
                                Consumer<Counter>(
                                  builder: (context, counter, child) {
                                    return Column(
                                      children: [
                                        const Text("\nHow many hours?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: MaterialButton(
                                                  textColor: Colors.white,
                                                  color: Colors.lightBlue,
                                                  onPressed: () {
                                                    counter.decrement();
                                                    dur = counter.x;
                                                  },
                                                  child: const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "${counter.x}",
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: MaterialButton(
                                                  textColor: Colors.white,
                                                  color: Colors.lightBlue,
                                                  onPressed: () {
                                                    counter.increment();
                                                    dur = counter.x;
                                                  },
                                                  child: const Text(
                                                    "+",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer<Cart>(
                    builder: (context, cart, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 10),
                        child: MaterialButton(
                          onPressed: () {
                            //PERVENT DOUBLE BOOKING HERE
                            if (cart.cartItems.isNotEmpty &&
                                ((cart.cartItems.last.end.isBefore(dateTime) &&
                                        (cart.cartItems.last.end
                                                    .difference(dateTime)
                                                    .inMinutes >=
                                                -29 ||
                                            cart.cartItems.last.start
                                                    .difference(dateTime)
                                                    .inMinutes >=
                                                -29)) ||
                                    (cart.cartItems.last.end
                                            .isAfter(dateTime) &&
                                        (cart.cartItems.last.end
                                                    .difference(dateTime)
                                                    .inMinutes <=
                                                29 ||
                                            cart.cartItems.last.start
                                                    .difference(dateTime)
                                                    .inMinutes <=
                                                29)))) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.bottomSlide,
                                title: "Attention!",
                                desc:
                                    "The date and time you picked for this service may overlap with another reservation in your cart, you may want to pick another timeslot.",
                                btnCancelText: "Ignore",
                                btnOkText: "Return",
                                btnCancelOnPress: () {
                                  Booking booking = Booking(
                                      serviceID: widget.data,
                                      start: dateTime,
                                      duration: dur,
                                      end: dateTime.add(Duration(hours: dur)),
                                      price: (double.parse(
                                              snapshot.data!["price"])) *
                                          dur);
                                  cart.add(booking);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.bottomSlide,
                                    title: "Successful Booking!",
                                    desc:
                                        "You may proceed to checkout or book another service.",
                                    btnOkOnPress: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              "home", (route) => false);
                                    },
                                  ).show();
                                },
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              Booking booking = Booking(
                                  serviceID: widget.data,
                                  start: dateTime,
                                  duration: dur,
                                  end: dateTime.add(Duration(hours: dur)),
                                  price:
                                      (double.parse(snapshot.data!["price"])) *
                                          dur);
                              cart.add(booking);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                title: "Successful Booking!",
                                desc:
                                    "You may proceed to checkout or book another service.",
                                btnOkOnPress: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "home", (route) => false);
                                },
                              ).show();
                            }
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.edit_calendar,
                                size: 40,
                              ),
                              Text(
                                "Book it!",
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            }
            return const Center(
                heightFactor: 500,
                child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
    );
  }
}

class Counter extends ChangeNotifier {
  int x = 1;
  increment() {
    x++;
    notifyListeners();
  }

  decrement() {
    if (x > 1) {
      x--;
      notifyListeners();
    }
  }

  reset() {
    x = 1;
    notifyListeners();
  }

  notTimed() {
    x = 0;
  }
}
