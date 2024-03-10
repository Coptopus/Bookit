import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashBanner extends StatefulWidget {
  const DashBanner({
    super.key,
  });

  @override
  State<DashBanner> createState() => _DashBannerState();
}

class _DashBannerState extends State<DashBanner> {
  String email = "${FirebaseAuth.instance.currentUser!.email}";
  // User user = User();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {Navigator.of(context).pushNamed("profile");},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                ),
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      "Hello, ${data['name']}! \nWhat are we up to today?",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      );
                  }

                  return const Text("loading");
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 226, 253),
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 0, 110, 238),
                    ),
                    onPressed: () {},
                  )),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color.fromARGB(255, 0, 110, 238),
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
