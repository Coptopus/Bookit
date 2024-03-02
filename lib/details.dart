import 'package:bookit/widgets.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final data;
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
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        title: appTitle,
      ),
      body: ListView(
        children: [
          SizedBox(height: 400, child: Image.asset(widget.data["img"], fit: BoxFit.cover,)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data["name"], style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),),
                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white,), width: 500, margin: EdgeInsets.symmetric(vertical: 20), padding: EdgeInsets.all(10), child: Text(widget.data["desc"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                Text("Location: ${widget.data["location"]}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                Text(widget.data["priceRng"], style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.blue),),
              ],
            ),
          ),
          Center(child: MaterialButton(onPressed: () {}, child: Text("Book it!", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),), color: Colors.blue, textColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),))
        ],
      ),
    );
  }
}