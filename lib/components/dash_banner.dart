import 'package:bookit/model/forrmatting.dart';
import 'package:bookit/pages/details.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
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
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("profile");
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
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
                      ),
                    ),
                    data['account_type'] == "Customer"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Hello, ",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "${data['name']}!",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              const Text(
                                "What are we up to today?",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              const Text(
                                "Welcome, ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${data['name']}.",
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                    fontSize: 25, fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                  ],
                ),
                data['account_type'] != "Customer"
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 209, 226, 253),
                                  borderRadius: BorderRadius.circular(30)),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Color.fromARGB(255, 0, 110, 238),
                                ),
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: ServiceSearch());
                                },
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

        return const Center(
          heightFactor: 500,
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );
  }
}

class ServiceSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('services')
          .orderBy('name')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            if (snapshot.data!.docs[i]['name']
                    .toString()
                    .toUpperCase()
                    .contains(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toUpperCase()
                    .startsWith(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toLowerCase()
                    .contains(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toLowerCase()
                    .startsWith(query)) {
              results.add(snapshot.data!.docs[i]);
            }
          }
          if (results.isEmpty) {
            return const Center(
              child: Text(
                "No results found :(",
                style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Details(data: results[index].id),
                  ));
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: results[index]['img'] != "none"
                            ? Image.network(
                                results[index]['img'],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 75,
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                height: 100,
                                width: 75,
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
                            results[index]['name'],
                            maxLines: 2,
                            softWrap: true,
                          ),
                          titleTextStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                results[index]['location'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (results[index]['oneTime'])
                                const Text(
                                  "One Time Event.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          trailing: results[index]['timed']
                              ? Text(
                                  "${money.format(double.parse(results[index]['price']))} / hr",
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                )
                              : Text(
                                  money.format(
                                      double.parse(results[index]['price'])),
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                        ),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('services')
          .orderBy('name')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            if (snapshot.data!.docs[i]['name']
                    .toString()
                    .toUpperCase()
                    .contains(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toUpperCase()
                    .startsWith(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toLowerCase()
                    .contains(query) ||
                snapshot.data!.docs[i]['name']
                    .toString()
                    .toLowerCase()
                    .startsWith(query)) {
              results.add(snapshot.data!.docs[i]);
            }
          }
          if (results.isEmpty) {
            return const Center(
              child: Text(
                "No results found :(",
                style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Details(data: results[index].id),
                  ));
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: results[index]['img'] != "none"
                            ? Image.network(
                                results[index]['img'],
                                fit: BoxFit.cover,
                                height: 100,
                                width: 75,
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                height: 100,
                                width: 75,
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
                            results[index]['name'],
                            maxLines: 2,
                            softWrap: true,
                          ),
                          titleTextStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                results[index]['location'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              if (results[index]['oneTime'])
                                const Text(
                                  "One Time Event.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          trailing: results[index]['timed']
                              ? Text(
                                  "${money.format(double.parse(results[index]['price']))} / hr",
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                )
                              : Text(
                                  money.format(
                                      double.parse(results[index]['price'])),
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                        ),
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
    );
  }
}
