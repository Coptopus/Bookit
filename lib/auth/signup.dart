import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
                Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LogoAuth(),
                      const Text("Let's get started!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),),
                      Text("Creating an account as a ${widget.accountType}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),
                      const SizedBox(height: 10,),
                  
                      CustomTextFormField(label: widget.accountType == "Customer"? "Full Name" : "Company name", hintText: "Enter your name", controller: name, validator: (val) {if (val == "") {return "*This field is required*";}return null;},),
                  
                      CustomTextFormField(label: "Email", hintText: "Enter your Email", controller: email, validator: (val) {if (val == "") {return "*This field is required*";}return null;},),
                  
                      CustomTextFormField(label: "Password", hintText: "Enter your Password", controller: password, obscureText: true, validator: (val) {if (val == "") {return "*This field is required*";}return null;},),
                  
                      CustomTextFormField(label: "Confirm password", hintText: "Re-enter your Password", controller: password2, obscureText: true, validator: (val) {if (val == "") {return "*This field is required*";}return null;},),
                  
                    ],
                  ),
                ),
                
                ButtonAuth(label: "Register", onPressed: () async {
                  if (formState.currentState!.validate()) {
                  try {
                    if (password.text == password2.text) {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text,);
                    if (!context.mounted) {return;}
                    Navigator.of(context).pushReplacementNamed("login");
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    AwesomeDialog(context: context, dialogType: DialogType.info, animType: AnimType.bottomSlide, title: "Almost there!", desc: "Please check your email for the verification link.", btnOkOnPress: () {},).show();
                    }
                    else {
                      AwesomeDialog(context: context, dialogType: DialogType.error, animType: AnimType.bottomSlide, title: "Error", desc: "Please check that the passwords match").show();
                      }

                    } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          if (!context.mounted) {return;} 
                          AwesomeDialog(context: context, dialogType: DialogType.error, animType: AnimType.bottomSlide, title: "Error", desc: "The password provided is too weak.").show();
                          } 
                        else if (e.code == 'email-already-in-use') {
                          if (!context.mounted) {return;}
                          AwesomeDialog(context: context, dialogType: DialogType.error, animType: AnimType.bottomSlide, title: "Error", desc: "The account already exists for that email.").show();
                          }
                        } catch (e) {if (kDebugMode) {print(e);}}

                  }
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