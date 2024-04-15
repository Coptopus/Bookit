import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/model/forrmatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../services/edit.dart';
import 'my_service.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  CollectionReference services =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      appBar: AppBar(
        foregroundColor: Colors.blue,
        title: const Text("My services", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: FutureBuilder(
        future: services
            .where('provider',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyService(
                        data: snapshot.data!.docs[index].id,
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
                          child: snapshot.data!.docs[index]['img'] != "none"
                              ? Image.network(
                                  snapshot.data!.docs[index]['img'],
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
                                snapshot.data!.docs[index]['name'],
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
                                    snapshot.data!.docs[index]['location'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (snapshot.data!.docs[index]['oneTime'])
                                    const Text(
                                      "One Time Event.",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  snapshot.data!.docs[index]['timed']
                                      ? Text(
                                          "${money.format(double.parse(snapshot.data!.docs[index]['price']))} / hr",
                                          style: const TextStyle(
                                              color: Colors.teal,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        )
                                      : Text(
                                          money.format(double.parse(snapshot
                                              .data!.docs[index]['price'])),
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
                                          "Are you sure you want to delete ${snapshot.data!.docs[index]['name']}?\n(This can't be undone)",
                                      btnOkText: "Yes",
                                      btnOkOnPress: () async {
                                        await FirebaseFirestore.instance
                                            .collection('services')
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();

                                        if (snapshot.data!.docs[index]['img'] !=
                                            "none") {
                                          FirebaseStorage.instance
                                              .refFromURL(snapshot
                                                  .data!.docs[index]['img'])
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
                                        result = await FirebaseFirestore
                                            .instance
                                            .collection('services')
                                            .doc(snapshot.data!.docs[index].id)
                                            .get();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditService(
                                        docID: snapshot.data!.docs[index].id,
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
                                            style: TextStyle(
                                                color: Colors.blueGrey),
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
                );
              },
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
