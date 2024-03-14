import 'package:bookit/components/dash_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({
    super.key,
  });

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  List<QueryDocumentSnapshot> data = [];

  getServiceData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('services').get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  void initState() {
    getServiceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const DashBanner(),

      data.isEmpty
          ? Center(
              child: Text("No Services Yet. :(",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  )))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Your services:",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline),
              ),
            ),

      //DISPLAY OWNED SERVICES
      ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            surfaceTintColor: Colors.white,
            color: Colors.white,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: Image.network(
                    data[index]['img'],
                    fit: BoxFit.cover,
                    height: 125,
                    width: 100,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(data[index]['name']),
                    titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]['location'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (data[index]['oneTime'])
                          Text(
                            "One Time Event.",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    trailing: 
                    data[index]['timed']?
                    Text(
                      "E£ ${data[index]['price']} / hr",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ):
                    Text(
                      "E£ ${data[index]['price']}",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      //ADD
      InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.blueGrey[50],
        onTap: () {
          Navigator.of(context).pushNamed("addServ");
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 125,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.blueGrey[700],
                size: 60,
              ),
              Text(
                "(Add a service)",
                style: TextStyle(fontSize: 25, color: Colors.blueGrey[700]),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
