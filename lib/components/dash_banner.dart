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
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(60)),
                  width: 60,
                  height: 60,
                  // child: ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.asset("assets/file.jpg", fit: BoxFit.cover)), //User profile pic
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const Text(
                "Hello, [name here]! \nWhat are we up to today?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
