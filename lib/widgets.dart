import 'package:bookit/details.dart';
import 'package:flutter/material.dart';

Widget appTitle = SizedBox(height: 45, child: Image.asset('assets/BookitTitle.png', fit: BoxFit.fitHeight,));

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(60)
                    ),
                    width: 60,
                    height: 60,
                    child:  ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.asset("assets/file.jpg", fit: BoxFit.cover)),
                  ),
                  const Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text("Asem Al Ashqar", style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text("ProfDrAshqar@gmail.com"),
                      )
                    )
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("My Account"),
            leading: const Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: const Text("My Reservations"),
            leading: const Icon(Icons.receipt),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.logout),
            onTap: () {Navigator.of(context).pushReplacementNamed("login");},
          ),
        ],
      ),
      );
  }

class InputField extends StatefulWidget {
  final String label;
  final TextInputType type;
  final bool obscured;
  const InputField({super.key, required this.label, required this.type, required this.obscured});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                TextFormField(
                  style: const TextStyle(fontSize: 20,),
                  maxLines: 1,
                  keyboardType: widget.type,
                  obscureText: widget.obscured,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 227, 233, 249),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
    ]);
  }
}

class SignButton extends StatefulWidget {
  final String text;
  const SignButton({super.key, required this.text});

  @override
  State<SignButton> createState() => _SignButtonState();
}

class _SignButtonState extends State<SignButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {}, 
      color: const Color.fromARGB(255, 168, 185, 230), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
      elevation: 0, 
      padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 15), 
      child: Text(widget.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),);
  }
}

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool x = false;
  
  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Checkbox(
                value: x, 
                onChanged: (value) {setState(() {x = !x;});},
                activeColor: const Color.fromARGB(255, 168, 185, 230),
                checkColor: Colors.black,
                ),
              const Text("Remember me", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                ],
              );
          }
}

class CategoriesList extends StatelessWidget {
  static List categories = [
    {
      "iconname": Icons.sports_soccer,
      "title": "Sports & Fitness",
      "num_places": 2
    },
    {
      "iconname": Icons.restaurant,
      "title": "Food",
      "num_places": 3
    },
    {
      "iconname": Icons.medical_services,
      "title": "Clinics",
      "num_places": 4
    },
    {
      "iconname": Icons.attractions,
      "title": "Entertainment",
      "num_places": 1
    },
  ];
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: Colors.lightBlue[200]), margin: const EdgeInsets.only(bottom: 15), child: Icon(categories[index]['iconname'], size: 50, color: Colors.blue[800],),),
                Text(categories[index]['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),),
                Text("${categories[index]['num_places']} places", style: TextStyle(color: Colors.grey[600], fontSize: 16),)
                ],
              )
            ),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.horizontal, 
      ),
    );
  }
}

class DashBanner extends StatelessWidget {
  const DashBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  child: ClipRRect(borderRadius: BorderRadius.circular(60), child: Image.asset("assets/file.jpg", fit: BoxFit.cover)),
                  // child: const Icon(Icons.person, color: Colors.white, size: 50,),
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
    );
  }
}

class DashList extends StatelessWidget {
  final String listTitle;
  const DashList({
    super.key, required this.listTitle,
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
              Text(listTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              InkWell(onTap: (){}, splashFactory: InkRipple.splashFactory, child: const Text("Show all", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold,),))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5), 
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemExtent: 200,
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
            return InkWell(
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(data: services[index]),));},
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 110,
                      child: Image.asset("${services[index]["img"]}", fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${services[index]["name"]}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: services[index]["rating"],
                                  itemBuilder: (context, index) {
                                    return const Icon(Icons.star, color: Colors.orange, size: 20,);
                                  },
                                  ),
                              ),
                              Expanded(child: Text("(${services[index]["numberOfRatings"]})", textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey),)),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
              ),
            );
          },),
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
      onTap: (value) {setState(() {currentIndex = value; });},
      iconSize: 35,
      selectedFontSize: 15,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "Services"),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings")
    ]);
  }
}

List services = [
  {
    "img":"assets/soccer.jpg",
    "name": "Soccer pitch",
    "type": "sports",
    "desc": "A soccer pitch available for booking.",
    "location":"Nasr City",
    "rating": 5,
    "numberOfRatings": 203,
    "priceRng": "50 EGP/hr"
  },
  {
    "img":"assets/padel.jpg",
    "name": "Padel court",
    "type": "sports",
    "desc": "Bring your friends and enjoy a few games of Padel equipped with a Padel and a couple tennis balls!",
    "location": "Sixth of October City",
    "rating": 4,
    "numberOfRatings": 357,
    "priceRng": "100 EGP/hr"
  },
];