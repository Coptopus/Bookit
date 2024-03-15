import 'package:bookit/components/drawer.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final dynamic data;
  const Details({super.key, this.data});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      drawer: appDrawer(context),
      // bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: appTitle,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.edit_calendar),
        label: const Text("Book it!",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('services')
            .doc(widget.data)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            DateTime dt = (snapshot.data!['oneTimeDate'] as Timestamp).toDate();
            return ListView(
              children: [
                SizedBox(
                  height: 400,
                  child: snapshot.data!["img"] != "none"
                      ? Image.network(
                          snapshot.data!["img"],
                          fit: BoxFit.cover,
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 300,
                          width: 500,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[300]),
                          child: const Icon(
                            Icons.photo,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!["name"],
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: 500,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            snapshot.data!["desc"],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location:",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${snapshot.data!["location"]}\n",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.circular(10)),
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            snapshot.data!["timed"]
                                ? Text(
                                    "E£ ${snapshot.data!["price"]} / hour",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.teal),
                                  )
                                : Text(
                                    "E£ ${snapshot.data!["price"]}",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.teal),
                                  ),
                            if (snapshot.data!['oneTime'])
                              Text(
                                "Event Date\n${dt.day} / ${dt.month} / ${dt.year}\n${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Center(child: MaterialButton(onPressed: () {}, color: Colors.blue, textColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), child: const Text("Book it!", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),),))
              ],
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
