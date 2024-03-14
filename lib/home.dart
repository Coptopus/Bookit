import 'package:bookit/components/drawer.dart';
import 'package:bookit/subpages/customer_home.dart';
import 'package:bookit/subpages/provider_home.dart';
import 'package:bookit/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        drawer: appDrawer(context),
        bottomNavigationBar: const BottomNavBar(),
        appBar: AppBar(
          title: appTitle,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (data['account_type'] == "Customer") {
                return const CustomerHome();
              } else if (data['account_type'] == "Service Provider") {
                return const ProviderHome();
              }
            }

            return const Center(
                heightFactor: 500,
                child: CircularProgressIndicator(color: Colors.blue));
          },
        ));
  }
}



