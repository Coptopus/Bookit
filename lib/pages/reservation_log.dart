import 'package:bookit/model/forrmatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'details.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  bool loading = true;
  List services = [];
  List serviceDat = [];
  List data = [];
  List dayta = [];
  List daytum = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('services').get();
    services = (querySnapshot.docs.map((e) => e.id).toList());
    serviceDat = (querySnapshot.docs.map((e) => e.data()).toList());
    for (var i = 0; i < services.length; i++) {
      QuerySnapshot subsnap = await FirebaseFirestore.instance
          .collection('services')
          .doc(services[i])
          .collection('reservations')
          .where('Customer', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      data.addAll(subsnap.docs
          .map((e) => {
                'ServiceId': services[i],
                'ServiceDat': serviceDat[i],
                'Reservation': e.data()
              })
          .toList());
    }

    for (var i = 0; i < data.length; i++) {
      if (DateTime.parse(
              data[i]['Reservation']['StartTime'].toDate().toString())
          .isAfter(DateTime.now())) {
        dayta.add(data[i]);
      } else if (DateTime.parse(
              data[i]['Reservation']['StartTime'].toDate().toString())
          .isBefore(DateTime.now())) {
        daytum.add(data[i]);
      }
    }
    dayta.sort(
      (a, b) {
        Timestamp one = a['Reservation']['StartTime'];
        Timestamp two = b['Reservation']['StartTime'];
        return one.compareTo(two);
      },
    );
    daytum.sort(
      (a, b) {
        Timestamp one = a['Reservation']['StartTime'];
        Timestamp two = b['Reservation']['StartTime'];
        return two.compareTo(one);
      },
    );
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      appBar: AppBar(
        foregroundColor: Colors.blue,
        title: const Text(
          "Reserved Services",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: loading
          ? const Center(
              child: Text("Loading"),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CURRENTLY RESERVED
                  //Add Cancelation algorithm ;)
                  const Row(
                    children: [
                      Icon(
                        Icons.book_online,
                        size: 45,
                      ),
                      Text(
                        " Reserved Services",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const Divider(),
                  dayta.isEmpty
                      ? const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                size: 50,
                                color: Colors.black26,
                              ),
                              Text(
                                "You have no upcoming reservations.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black38),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dayta.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => Details(
                                            data: dayta[index]['ServiceId']),
                                      ));
                                    },
                                    child: Card(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10)),
                                            child: dayta[index]['ServiceDat']
                                                        ['img'] !=
                                                    "none"
                                                ? Image.network(
                                                    dayta[index]['ServiceDat']
                                                        ['img'],
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        color:
                                                            Colors.grey[300]),
                                                    child: const Icon(
                                                      Icons.photo,
                                                      size: 50,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              title: Text(
                                                dayta[index]['ServiceDat']
                                                    ['name'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              titleTextStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  dayta[index]['ServiceDat']
                                                          ['timed']
                                                      ? Text(
                                                          "${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).day}/${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).month}/${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).year}\n${ftime.format(DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()))} ~ ${ftime.format(DateTime.parse(dayta[index]['Reservation']['EndTime'].toDate().toString()))}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(
                                                          "${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).day}/${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).month}/${DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()).year}\n${ftime.format(DateTime.parse(dayta[index]['Reservation']['StartTime'].toDate().toString()))}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                  if (dayta[index]['ServiceDat']
                                                      ['oneTime'])
                                                    const Text(
                                                      "One Time Event.",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                ],
                                              ),
                                              trailing: dayta[index]
                                                      ['ServiceDat']['timed']
                                                  ? Column(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            money.format(dayta[index]['Reservation']['Price']),
                                                            style: const TextStyle(
                                                                color: Colors.teal,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight.w900),
                                                          ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            "${dayta[index]['Reservation']['Duration']} hour(s)",
                                                            style: const TextStyle(
                                                                color: Colors.teal,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight.w900),
                                                          ),
                                                      ),
                                                    ],
                                                  )
                                                  : Text(
                                                      money.format(dayta[index]
                                                              ['Reservation']
                                                          ['Price']),
                                                      style: const TextStyle(
                                                          color: Colors.teal,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        print("Cancel");
                                      },
                                      icon: const Stack(
                                        alignment: Alignment.center,
                                        children: [
                                        Icon(
                                          Icons.cancel,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 15),
                                          ],
                                          color: Colors.deepOrange,
                                        ),
                                        Icon(Icons.clear, color: Colors.black, size: 19)
                                      ]))
                                ],
                              );
                            },
                          ),
                        ),
                  const Divider(),

                  //PREVIOUSLY RESERVED
                  const Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 40,
                      ),
                      Text(
                        " History",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const Divider(),
                  daytum.isEmpty
                      ? const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                size: 50,
                                color: Colors.black26,
                              ),
                              Text(
                                "Nothing in your History.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black38),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: daytum.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Details(
                                        data: daytum[index]['ServiceId']),
                                  ));
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        child: daytum[index]['ServiceDat']
                                                    ['img'] !=
                                                "none"
                                            ? Image.network(
                                                daytum[index]['ServiceDat']
                                                    ['img'],
                                                fit: BoxFit.cover,
                                                height: 100,
                                                width: 100,
                                                color: Colors.black87,
                                                colorBlendMode: BlendMode.color,
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Colors.grey[300]),
                                                child: const Icon(
                                                  Icons.photo,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          title: Text(
                                            daytum[index]['ServiceDat']['name'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          titleTextStyle: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              daytum[index]['ServiceDat']
                                                      ['timed']
                                                  ? Text(
                                                      "${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).day}/${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).month}/${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).year}\n${ftime.format(DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()))} ~ ${ftime.format(DateTime.parse(daytum[index]['Reservation']['EndTime'].toDate().toString()))}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).day}/${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).month}/${DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()).year}\n${ftime.format(DateTime.parse(daytum[index]['Reservation']['StartTime'].toDate().toString()))}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                              if (daytum[index]['ServiceDat']
                                                  ['oneTime'])
                                                const Text(
                                                  "One Time Event.",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                            ],
                                          ),
                                          trailing: daytum[index]['ServiceDat']
                                                  ['timed']
                                              ? Text(
                                                  "${money.format(daytum[index]['Reservation']['Price'])}\n${daytum[index]['Reservation']['Duration']} hour(s)",
                                                  style: const TextStyle(
                                                      color: Colors.teal,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )
                                              : Text(
                                                  money.format(daytum[index]
                                                      ['Reservation']['Price']),
                                                  style: const TextStyle(
                                                      color: Colors.teal,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
