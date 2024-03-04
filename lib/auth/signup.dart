import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController password2 = TextEditingController();

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

                    CustomTextFormField(label: "Confirm password", hintText: "Re-enter your Password", controller: password2, obscureText: true,),

                  ],
                ),
                
                ButtonAuth(label: "Register", onPressed: () async {
                  try {
                    if (password.text == password2.text) {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text,);
                    Navigator.of(context).pushReplacementNamed("home");
                    }
                    else {print("Incorrect password");}

                    } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {print('The password provided is too weak.');} 
                        else if (e.code == 'email-already-in-use') {print('The account already exists for that email.');}
                        } catch (e) {print(e);}
                }),

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