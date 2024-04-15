import 'package:bookit/components/drawer.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/model/forrmatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  final dynamic data;
  const MyService({super.key, this.data});

  @override
  State<MyService> createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      drawer: appDrawer(context),
      appBar: AppBar(
        title: appTitle,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('services')
            .doc(widget.data)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            DateTime dt = (snapshot.data!['oneTimeDate'] as Timestamp).toDate();
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            "${snapshot.data!["location"]}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(10)),
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
                                    money.format(
                                        double.parse(snapshot.data!["price"])),
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
                      //View Reservations
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('services')
                            .doc(widget.data)
                            .collection('reservations')
                            .where('StartTime',
                                isGreaterThanOrEqualTo: DateTime.now())
                            .orderBy('StartTime')
                            .get(),
                        builder: (context, result) {
                          if (result.connectionState == ConnectionState.done) {
                            if (result.hasData &&
                                result.data!.docs.isNotEmpty) {
                              return Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Divider(),
                                      const Text(
                                        "Number Of Current Bookings:",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Text(
                                          result.data!.docs.length.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                              color: result.data!.docs.length <=
                                                      10
                                                  ? Colors.green
                                                  : result.data!.docs.length <=
                                                          30
                                                      ? Colors.amber[800]
                                                      : Colors.red[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                      const Text(
                                        "Reservations:",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: result.data!.size,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Divider(),
                                              FutureBuilder(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(result
                                                              .data!.docs[index]
                                                          ['Customer'])
                                                      .get(),
                                                  builder: (context, user) {
                                                    if (user.connectionState ==
                                                        ConnectionState.done) {
                                                      return Text(
                                                        snapshot.data!["timed"]
                                                            ? "${user.data!['name']}\n${fdate.format(DateTime.parse(result.data!.docs[index]['StartTime'].toDate().toString()))} ~ ${ftime.format(DateTime.parse(result.data!.docs[index]['EndTime'].toDate().toString()))}"
                                                            : "${user.data!['name']}\n${fdate.format(DateTime.parse(result.data!.docs[index]['StartTime'].toDate().toString()))}",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                    .deepPurple[
                                                                900]),
                                                      );
                                                    }
                                                    return const Text(
                                                        "Loading");
                                                  }),
                                            ],
                                          );
                                        },
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                heightFactor: 1.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(),
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: 50,
                                      color: Colors.black26,
                                    ),
                                    Text(
                                      "No reservations on this service yet.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black38),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            }
                          }
                          return const Center(
                            heightFactor: 500,
                            child: CircularProgressIndicator(
                              color: Colors.lightBlue,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
              heightFactor: 500,
              child: CircularProgressIndicator(color: Colors.blue));
        },
      ),
    );
  }
}
