import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoAuth(),
                    const Text("Welcome Back!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),),
                    const Text("Login to continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),
                    const SizedBox(height: 10,),

                    CustomTextFormField(label: "Email", hintText: "Enter your Email", controller: email),

                    CustomTextFormField(label: "Password", hintText: "Enter your Password", controller: password, obscureText: true,),

                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20, right: 10), 
                      alignment: Alignment.topRight, 
                      child: InkWell(onTap: () {}, child: const Text("Forgot Password?", style: TextStyle(fontSize: 17),))), //Forgot Password
                  ],
                ),
                
                ButtonAuth(label: "Login", onPressed: (){}),

                const SizedBox(height: 20,),
                
                InkWell(
                  onTap: () {Navigator.of(context).pop();},
                  child: const Center(
                    child: Text.rich(
                      TextSpan(children: [
                      TextSpan(text: "New to Bookit? ",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      TextSpan(text: "Create an account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline, decorationColor: Color.fromRGBO(93, 125, 212, 1), color: Color.fromRGBO(93, 125, 212, 1)))
                    ] )),
                  ),
                )
          ],
        ),
      ),
    );
  }
}