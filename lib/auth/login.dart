import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LogoAuth(),
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w900),
                        ),
                        const Text(
                          "Login to continue",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          label: "Email",
                          hintText: "Enter your Email",
                          controller: email,
                          validator: (val) {
                            if (val == "") {
                              return "*This field is required*";
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                          label: "Password",
                          hintText: "Enter your Password",
                          controller: password,
                          obscureText: true,
                          validator: (val) {
                            if (val == "") {
                              return "*This field is required*";
                            }
                            return null;
                          },
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 20, right: 10),
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () async {
                                  if (email.text == "") {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: "To Reset Password",
                                      desc:
                                          "Please enter your email in the 'Email' and try again.",
                                      btnOkOnPress: () {},
                                    ).show();
                                    return;
                                  }
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: email.text);
                                    if (!context.mounted) {
                                      return;
                                    }
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.bottomSlide,
                                      title: "Reset Password",
                                      desc:
                                          "Please check your email for the password reset link.",
                                      btnOkOnPress: () {},
                                    ).show();
                                  } catch (e) {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: "Reset Password",
                                      desc:
                                          "Please make sure you entered the correct email",
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(fontSize: 17),
                                ))),
                      ],
                    ),
                  ),
                  ButtonAuth(
                      label: "Login",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            loading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            loading = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              if (!context.mounted) {
                                return;
                              }
                              Navigator.of(context)
                                  .pushReplacementNamed("home");
                            } else {
                              if (!context.mounted) {
                                return;
                              }
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.bottomSlide,
                                title: "Almost there!",
                                desc:
                                    "Please check your email for the verification link.",
                                btnOkOnPress: () {},
                                btnCancelText: "Re-send verfication link",
                                btnCancelOnPress: () {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                },
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            loading = false;
                            setState(() {});
                            if (e.code == 'user-not-found') {
                              if (!context.mounted) {
                                return;
                              }
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: "Error",
                                      desc: "No user found for that email.")
                                  .show();
                            } else if (e.code == 'wrong-password') {
                              if (!context.mounted) {
                                return;
                              }
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: "Error",
                                      desc:
                                          "Wrong password provided for that user.")
                                  .show();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.bottomSlide,
                                title: "Error",
                                desc: "$e",
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("welcome");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "New to Bookit? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        TextSpan(
                            text: "Create an account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromRGBO(93, 125, 212, 1),
                                color: Color.fromRGBO(93, 125, 212, 1)))
                      ])),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
