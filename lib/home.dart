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
          DashBanner(),
          CategoriesList(),
          DashList(listTitle: 'Popular pitches & courts',),

        ]
      ),
    );
  }
}

