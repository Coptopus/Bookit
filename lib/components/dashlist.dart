import 'package:bookit/model/forrmatting.dart';
import 'package:bookit/pages/details.dart';
import 'package:bookit/subpages/some_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashList extends StatelessWidget {
  final String listTitle;
  final String categ;
  const DashList({
    super.key,
    required this.listTitle,
    required this.categ,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listTitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SomeServices(categ: categ)));
                  },
                  splashFactory: InkRipple.splashFactory,
                  child: const Text(
                    "Show all",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('services')
                    .where('type', isEqualTo: categ)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Details(data: snapshot.data!.docs[index].id),
                        ));
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 110,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.network(
                                        "${snapshot.data!.docs[index]["img"]}",
                                        fit: BoxFit.cover)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data!.docs[index]["name"]}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),

                                    snapshot.data!.docs[index]['timed']
                                        ? Text(
                                            "${money.format(double.parse(snapshot.data!.docs[index]["price"]))} / hr",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16,
                                                color: Colors.teal),
                                          )
                                        : Text(
                                            money.format(double.parse(snapshot.data!.docs[index]["price"])),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16,
                                                color: Colors.teal),
                                          ),
                                    if (snapshot.data!.docs[index]['oneTime'])
                                      const Text(
                                        "One Time Event.",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    // RATINGS SUBSYSTEM TO BE IMPLEMENTED LATER
                                    // Row(
                                    //   children: [
                                    //     SizedBox(
                                    //       height: 20,
                                    //       child: ListView.builder(
                                    //         scrollDirection: Axis.horizontal,
                                    //         physics:
                                    //             const NeverScrollableScrollPhysics(),
                                    //         shrinkWrap: true,
                                    //         itemCount:  snapshot.data!.docs[index]["rating"],
                                    //         itemBuilder: (context, index) {
                                    //           return const Icon(
                                    //             Icons.star,
                                    //             color: Colors.orange,
                                    //             size: 20,
                                    //           );
                                    //         },
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //         child: Text(
                                    //       "(${ snapshot.data!.docs[index]["numberOfRatings"]})",
                                    //       textAlign: TextAlign.end,
                                    //       style: const TextStyle(color: Colors.grey),
                                    //     )),
                                    //   ],
                                    // )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    );
                  }
                  return const Center(
                      heightFactor: 500,
                      child: CircularProgressIndicator(color: Colors.blue));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}