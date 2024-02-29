import 'package:bookit/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      drawer: appDrawer(context),
      appBar: AppBar(
        title: appTitle,
      ),
      body: ListView(
        children: [
          Padding(
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
                          borderRadius: BorderRadius.circular(60)
                        ),
                        width: 60,
                        height: 60,
                        child: const Icon(Icons.person, color: Colors.white, size: 50,),
                      ),
                    ),
                    const Text("Hello, Asem! \nWhat are we up to today?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: const Color.fromARGB(255, 209, 226, 253), borderRadius: BorderRadius.circular(30)),
                       child: IconButton(icon: const Icon(Icons.search, color: Color.fromARGB(255, 0, 110, 238),), onPressed: () {},)),
                    IconButton(icon: const Icon(Icons.notifications_outlined, color: Color.fromARGB(255, 0, 110, 238),), onPressed: () {},),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(                                                                       //Categories
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 175,
                
              );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal, 
            ),
          )
        ]
      ),
    );
  }

}