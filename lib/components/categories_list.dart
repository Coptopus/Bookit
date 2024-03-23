import 'package:bookit/subpages/some_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  static List categories = [
    {
      "iconname": Icons.sports_soccer,
      "title": "Sports & Fitness",
    },
    {
      "iconname": Icons.restaurant,
      "title": "Food",
    },
    {
      "iconname": Icons.medical_services,
      "title": "Clinics",
    },
    {
      "iconname": Icons.attractions,
      "title": "Entertainment",
    },
    {
      "iconname": Icons.more_horiz_outlined,
      "title": "Other",
    },
  ];
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('services')
                .where('type', isEqualTo: categories[index]['title'])
                .count()
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return InkWell(
                  borderRadius: BorderRadius.circular(30),
                  splashColor: Colors.lightBlue[100],
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SomeServices(categ: categories[index]['title']),
                    ));
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      margin: const EdgeInsets.all(5),
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.lightBlue[200]),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Icon(
                              categories[index]['iconname'],
                              size: 40,
                              color: Colors.blue[800],
                            ),
                          ),
                          Text(
                            categories[index]['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 15),
                          ),
                          Text(
                            "${snapshot.data!.count} places",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                        ],
                      )),
                );
              }

              return const Center(
                  heightFactor: 500,
                  widthFactor: 2,
                  child: CircularProgressIndicator(color: Colors.blue));
            },
          );
        },
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
