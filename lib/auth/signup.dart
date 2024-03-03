import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  final String accountType;
  const SignUp({super.key, required this.accountType});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController name = TextEditingController();
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
                    const Text("Let's get started!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),),
                    Text("Creating an account as a ${widget.accountType}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),
                    const SizedBox(height: 10,),

                    CustomTextFormField(label: widget.accountType == "Customer"? "Full Name" : "Company name", hintText: "Enter your name", controller: name),

                    CustomTextFormField(label: "Email", hintText: "Enter your Email", controller: email),

                    CustomTextFormField(label: "Password", hintText: "Enter your Password", controller: password, obscureText: true,),

                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20, right: 10), 
                      alignment: Alignment.topRight, 
                      child: InkWell(onTap: () {}, child: const Text("Forgot Password?", style: TextStyle(fontSize: 17),))), //Forgot Password
                  ],
                ),
                
                ButtonAuth(label: "Register", onPressed: (){}),

                const SizedBox(height: 20,),
                
                InkWell(
                  onTap: () {Navigator.of(context).pushReplacementNamed("login");},
                  child: const Center(
                    child: Text.rich(
                      TextSpan(children: [
                      TextSpan(text: "Already have an account? ",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      TextSpan(text: "Sign in", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.underline, decorationColor: Color.fromRGBO(93, 125, 212, 1), color: Color.fromRGBO(93, 125, 212, 1)))
                    ] )),
                  ),
                )
          ],
        ),
      ),
    );
  }
}