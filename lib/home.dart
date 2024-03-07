import 'package:bookit/components/dash_banner.dart';
import 'package:bookit/widgets.dart';
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
      body: ListView(children: const [
        DashBanner(),
        CategoriesList(),
        DashList(
          listTitle: 'Popular pitches & courts',
        ),
        DashList(
          listTitle: 'Restaurants you might like',
        ),
      ]),
    );
  }
}
