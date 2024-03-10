import 'package:bookit/details.dart';
import 'package:flutter/material.dart';

Widget appTitle = SizedBox(
    height: 45,
    child: Image.asset(
      'assets/BookitTitle.png',
      fit: BoxFit.fitHeight,
    ));

class CategoriesList extends StatelessWidget {
  static List categories = [
    {"iconname": Icons.sports_soccer,"title": "Sports & Fitness","num_places": 2},
    {"iconname": Icons.restaurant, "title": "Food", "num_places": 2},
    {"iconname": Icons.medical_services, "title": "Clinics", "num_places": 0},
    {"iconname": Icons.attractions, "title": "Entertainment", "num_places": 0},
  ];
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 5, right: 5),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.lightBlue[100],
            onTap: () {},
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
                          fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      "${categories[index]['num_places']} places",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    )
                  ],
                )),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class DashList extends StatelessWidget {
  final String listTitle;
  final int increment;
  const DashList({
    super.key,
    required this.listTitle, required this.increment,
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
                  onTap: () {},
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
              index += increment;
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Details(data: services[index]),
                  ));
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 110,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Image.asset("${services[index]["img"]}",
                                  fit: BoxFit.cover)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${services[index]["name"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "${services[index]["priceRng"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: Colors.teal),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: services[index]["rating"],
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 20,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "(${services[index]["numberOfRatings"]})",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(color: Colors.grey),
                                  )),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        iconSize: 35,
        selectedFontSize: 15,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: "Services"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Settings")
        ]);
  }
}

List services = [
  {
    "img": "assets/soccer.jpg",
    "name": "Soccer pitch",
    "type": "sports",
    "desc": "A soccer pitch available for booking.",
    "location": "Nasr City",
    "rating": 5,
    "numberOfRatings": 203,
    "priceRng": "E£ 50 / hr"
  },
  {
    "img": "assets/padel.jpg",
    "name": "Padel court",
    "type": "sports",
    "desc":
        "Bring your friends and enjoy a few games of Padel equipped with a Padel and a couple tennis balls!",
    "location": "Sixth of October City",
    "rating": 4,
    "numberOfRatings": 357,
    "priceRng": "E£ 100 / hr"
  },
  {
    "img": "assets/baraka.jpg",
    "name": "Baraka Fried Chicken",
    "type": "food",
    "desc":
        "Best fried chicken you'll ever have!",
    "location": "Al montazah",
    "rating": 5,
    "numberOfRatings": 500,
    "priceRng": "E£ 85 - 250"
  },
  {
    "img": "assets/italian.jpg",
    "name": "Virgollini's",
    "type": "food",
    "desc":
        "A sophisticated restaurant offering an assortment of exquisite dishes.",
    "location": "Zamalek, Cairo",
    "rating": 5,
    "numberOfRatings": 100,
    "priceRng": "E£ 150 - 350"
  },
];
