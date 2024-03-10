import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Drawer appDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {Navigator.of(context).pushNamed("profile");},
            child: Row(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(60)),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                  // child:  ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.asset("assets/file.jpg", fit: BoxFit.cover)), //User profile pic
                ),
                Expanded(
                    child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          "${data['name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }

                      return const Text("loading");
                    },
                  ),
                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          "${data['email']}",
                        );
                      }

                      return const Text("loading");
                    },
                  ),
                ))
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text("My Account"),
          leading: const Icon(Icons.person),
          onTap: () {Navigator.of(context).pushNamed("profile");},
        ),
        ListTile(
          title: const Text("My Reservations"),
          leading: const Icon(Icons.receipt),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Settings"),
          leading: const Icon(Icons.settings),
          onTap: () {},
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
      ],
    ),
  );
}
