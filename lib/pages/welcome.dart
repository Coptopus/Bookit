import 'package:bookit/auth/signup.dart';
import 'package:bookit/components/logoauth.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: appTitle),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20), child: const LogoAuth()),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome to Bookit!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
              ),
              Text(
                "Please select your account type to get started",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    String accountType = "Customer";
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUp(
                        accountType: accountType,
                      ),
                    ));
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          border: Border.all(
                              color: const Color.fromARGB(255, 11, 99, 158),
                              width: 5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 150,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Customer",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    String accountType = "Service Provider";
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUp(
                        accountType: accountType,
                      ),
                    ));
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[400],
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.business,
                          size: 150,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Service Provider",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "[*] Customers can make reservations for a variety of services.\n\n[*] Providers promote their services for potential customers.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("login");
                },
                color: const Color.fromARGB(255, 168, 185, 230),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                child: const Text(
                  "Go to login page",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
