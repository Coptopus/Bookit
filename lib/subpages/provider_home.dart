import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/components/dash_banner.dart';
import 'package:bookit/model/forrmatting.dart';
import 'package:bookit/services/edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/my_service.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({
    super.key,
  });

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  List<QueryDocumentSnapshot> data = [];

  getServiceData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('services')
        .orderBy('name')
        .where('provider', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getServiceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const DashBanner(),

      data.isEmpty
          ? const Center(
              heightFactor: 3,
              child: Text("No Services Yet. :(",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  )))
          : const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Your services:",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline),
              ),
            ),

      //DISPLAY OWNED SERVICES
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyService(
                      data: data[index].id,
                    ),
                  ));
                },
                child: Card(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: data[index]['img'] != "none"
                            ? Image.network(
                                data[index]['img'],
                                fit: BoxFit.cover,
                                height: 125,
                                width: 100,
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                height: 125,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
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
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              data[index]['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            titleTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['location'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                if (data[index]['oneTime'])
                                  const Text(
                                    "One Time Event.",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                data[index]['timed']
                                    ? Text(
                                        "${money.format(double.parse(data[index]['price']))} / hr",
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      )
                                    : Text(
                                        money.format(
                                            double.parse(data[index]['price'])),
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              surfaceTintColor: Colors.white,
                              color: Colors.white,
                              onSelected: (value) async {
                                if (value == "d") {
                                  //DELETE
                                  AwesomeDialog(
                                    context: this.context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.bottomSlide,
                                    title: "WARNING",
                                    desc:
                                        "Are you sure you want to delete ${data[index]['name']} and refund current reservations?\n(This can't be undone)",
                                    btnOkText: "Yes",
                                    btnOkOnPress: () async {
                                      //Check for any reservations before deleting then issue refunds

                                      var resCount = await FirebaseFirestore
                                          .instance
                                          .collection('services')
                                          .doc(data[index].id)
                                          .collection('reservations')
                                          .where('StartTime',
                                              isGreaterThanOrEqualTo:
                                                  DateTime.now())
                                          .count()
                                          .get();

                                      var penalty = ((resCount.count)! *
                                              double.parse(
                                                  data[index]['price'])) *
                                          -1;

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'points': FieldValue.increment(penalty)
                                      });

                                      List reservations = [];

                                      QuerySnapshot response =
                                          await FirebaseFirestore.instance
                                              .collection('services')
                                              .doc(data[index].id)
                                              .collection('reservations')
                                              .get();

                                      reservations = response.docs
                                          .map((e) => e.id)
                                          .toList();
                                      for (var i = 0;
                                          i < reservations.length;
                                          i++) {
                                        await FirebaseFirestore.instance
                                            .collection('services')
                                            .doc(data[index].id)
                                            .collection('reservations')
                                            .doc(reservations[i])
                                            .delete();
                                      }

                                      await FirebaseFirestore.instance
                                          .collection('services')
                                          .doc(data[index].id)
                                          .delete();

                                      if (data[index]['img'] != "none") {
                                        FirebaseStorage.instance
                                            .refFromURL(data[index]['img'])
                                            .delete();
                                      }

                                      if (!context.mounted) {
                                        return;
                                      }
                                      Navigator.of(context)
                                          .pushReplacementNamed('home');
                                    },
                                    btnCancelText: "No",
                                    btnCancelOnPress: () {},
                                  ).show();
                                } else if (value == "e") {
                                  //EDIT
                                  DocumentSnapshot<Map<String, dynamic>>
                                      result = await FirebaseFirestore.instance
                                          .collection('services')
                                          .doc(data[index].id)
                                          .get();
                                  if (!context.mounted) {
                                    return;
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditService(
                                      docID: data[index].id,
                                      data: result,
                                    ),
                                  ));
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: "e",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey,
                                        ),
                                        Text(
                                          "Edit",
                                          style:
                                              TextStyle(color: Colors.blueGrey),
                                        )
                                      ],
                                    )),
                                const PopupMenuItem(
                                    value: "d",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ))
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      //ADD
      InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.blueGrey[50],
        onTap: () {
          Navigator.of(context).pushNamed("addServ");
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            border: Border.all(width: 2, color: Colors.green),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 125,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.green,
                size: 60,
              ),
              Text(
                "Add a service",
                style: TextStyle(fontSize: 25, color: Colors.green),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
