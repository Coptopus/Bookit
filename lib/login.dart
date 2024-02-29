import 'package:bookit/widgets.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appTitle,),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),),
                Text("Login to continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const InputField(label: "Email", type: TextInputType.emailAddress, obscured: false),
                const SizedBox(height: 40,),
                const InputField(label: "Password", type: TextInputType.visiblePassword, obscured: true),
                const SizedBox(height: 20),
                const RememberMe(),
                const SizedBox(height: 20),
                MaterialButton(
                  onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);}, 
                  color: const Color.fromARGB(255, 168, 185, 230), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                  elevation: 0, 
                  padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 15), 
                  child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),),
                const SizedBox(height: 20,),
                const Text("New to Bookit?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                InkWell(
                  onTap: () {Navigator.of(context).pushReplacementNamed("welcome");}, 
                  child: const Text("Create an account here.", 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, 
                        decoration: TextDecoration.underline, 
                        decorationColor: Color.fromRGBO(93, 125, 212, 1), 
                        color: Color.fromRGBO(93, 125, 212, 1)), ))
              ],
            )
          )
        ]
        ),
    );
  }
}