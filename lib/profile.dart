import 'package:bookit/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List buttons = [
                data['account_type'] == "Customer"
                    ? {
                        "icon": Icons.list,
                        "label": "Reserved Services",
                        "onPressed": () {
                          if (kDebugMode) {
                            print("Services");
                          }
                        }
                      }
                    : {
                        "icon": Icons.point_of_sale,
                        "label": "My Services",
                        "onPressed": () {
                          if (kDebugMode) {
                            print("Services");
                          }
                        }
                      },
                {
                  "icon": Icons.star,
                  "label": "Bookit +",
                  "onPressed": () {
                    if (kDebugMode) {
                      print("Premium");
                    }
                  }
                },
                {
                  "icon": Icons.settings,
                  "label": "Settings",
                  "onPressed": () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
                  }
                },
                {
                  "icon": Icons.logout,
                  "label": "Logout",
                  "onPressed": () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                }
              ];
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                children: [
                  Column(children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(60)),
                      width: 100,
                      height: 100,
                      child: data['account_type'] == "Customer"
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 90,
                            )
                          : const Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 90,
                            ),
                    ),
                    Text(
                      "${data['name']}",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${data['email']}",
                      style: const TextStyle(fontSize: 15),
                    )
                  ]),
                  data['account_type'] == "Customer"
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "${data['points']}",
                                      style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white),
                                    ),
                                    const Text(
                                      "points",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                    left: 10, top: 20, bottom: 20),
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue[100],
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Earn more points",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    MaterialButton(
                                      onPressed: () {},
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Text(
                                        "How?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.teal[300],
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "\$ ${data['points']}",
                                  style: const TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                                const Text(
                                  "Revenue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: buttons.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MaterialButton(
                            onPressed: buttons[index]["onPressed"],
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child: Icon(buttons[index]["icon"])),
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${buttons[index]['label']}",
                                      style: const TextStyle(fontSize: 35),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            }
            return const Center(
                heightFactor: 500,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
          },
        ));
  }
}
