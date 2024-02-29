import 'package:flutter/material.dart';

Widget appTitle = SizedBox(height: 45, child: Image.asset('assets/BookitTitle.png', fit: BoxFit.fitHeight,));

  Drawer appDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
                    child: const Icon(Icons.person, color: Colors.white, size: 50,),
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
          Align(
            child: ListTile(
              title: const Text("Log Out"),
              leading: const Icon(Icons.logout),
              onTap: () {Navigator.of(context).pushReplacementNamed("login");},
            ),
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
                TextField(
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