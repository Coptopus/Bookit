import 'package:bookit/components/categories_list.dart';
import 'package:bookit/components/dash_banner.dart';
import 'package:bookit/widgets.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({
    super.key,
  });

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: const [
      DashBanner(),
      CategoriesList(),
      DashList(
        listTitle: 'Popular pitches & courts',
        categ: "Sports & Fitness",
      ),
      DashList(
        listTitle: 'Restaurants you might like',
        categ: "Food",
      ),
    ]);
  }
}
