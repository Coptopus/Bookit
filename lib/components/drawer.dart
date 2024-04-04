import 'package:bookit/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer appDrawer(BuildContext context) {
  return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("profile");
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(60)),
                            width: 60,
                            height: 60,
                            child: data['account_type'] == "Customer"
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  )
                                : const Icon(
                                    Icons.business,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                            // child:  ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.asset("assets/file.jpg", fit: BoxFit.cover)), //User profile pic
                          ),
                          Expanded(
                              child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    "${data['name']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${data['email']}",
                                  )))
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text("My Account"),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      Navigator.of(context).pushNamed("profile");
                    },
                  ),
                  data['account_type'] == "Customer"
                      ? ListTile(
                          title: const Text("My Reservations"),
                          leading: const Icon(Icons.receipt),
                          onTap: () {},
                        )
                      : ListTile(
                          title: const Text("My Services"),
                          leading: const Icon(Icons.point_of_sale),
                          onTap: () {},
                        ),
                  ListTile(
                    title: const Text("Settings"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ));
                    },
                  ),
                  ListTile(
                    title: const Text("Log Out"),
                    leading: const Icon(Icons.logout),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("login", (route) => false);
                    },
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/BookitTitle.png',
                                  fit: BoxFit.fitWidth,
                                  width: 100,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text("\u00a9 2024 Bookit \u2122"),
                              )
                            ],
                          ))),
                ],
              ),
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
