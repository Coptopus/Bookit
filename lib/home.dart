import 'package:bookit/components/drawer.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/settings.dart';
import 'package:bookit/subpages/all_services.dart';
import 'package:bookit/subpages/customer_home.dart';
import 'package:bookit/subpages/provider_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List<Widget> listWidget = [
    const Dashboard(),
    const AllServices(),
    const Dashboard(),
    const SettingsPage(),
  ];

    List<Widget> listWidget2 = [
    const Dashboard(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        drawer: appDrawer(context),
        bottomNavigationBar: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (data['account_type'] == "Customer") {
                return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentIndex,
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    iconSize: 35,
                    selectedFontSize: 15,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.list_alt_outlined),
                          label: "Services"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart_outlined),
                          label: "Cart"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings_outlined),
                          label: "Settings")
                    ]);
              } else {
                return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentIndex,
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    iconSize: 35,
                    selectedFontSize: 15,
                    selectedItemColor: Colors.blueGrey[800],
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings_outlined),
                          label: "Settings")
                    ]);
              }
            }
            return const Center(
                heightFactor: 500,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
          },
        ),
        appBar: AppBar(
          title: appTitle,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (data['account_type'] == "Customer") {
                return listWidget.elementAt(currentIndex);
              } else {
                return listWidget2.elementAt(currentIndex);
              }
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

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
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
    );
  }
}
