import 'package:bookit/model/forrmatting.dart';
import 'package:bookit/pages/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SomeServices extends StatefulWidget {
  final String categ;
  const SomeServices({super.key, required this.categ});

  @override
  State<SomeServices> createState() => _SomeServicesState();
}

class _SomeServicesState extends State<SomeServices> {
  CollectionReference services =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        appBar: AppBar(
          title: Text(
            widget.categ,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          foregroundColor: Colors.blue,
        ),
        body: FutureBuilder(
          future: services.where('type', isEqualTo: widget.categ).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Details(data: snapshot.data!.docs[index].id),
                      ));
                    },
                    child: Card(
                      margin:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                                maxLines: 2,
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
                                ],
                              ),
                              trailing: snapshot.data!.docs[index]['timed']
                                  ? Text(
                                      "${money.format(double.parse(snapshot.data!.docs[index]['price']))} / hr",
                                      style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    )
                                  : Text(
                                      money.format(double.parse(
                                          snapshot.data!.docs[index]['price'])),
                                      style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 20,
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
        ));
  }
}
