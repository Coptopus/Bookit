import 'package:bookit/firebase_options.dart';
import 'package:bookit/home.dart';
import 'package:bookit/login.dart';
import 'package:bookit/register.dart';
import 'package:bookit/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black
        )
      ),
      home: const Welcome(),
      routes: {
        "welcome":(context) => const Welcome(),
        "login":(context) => const Login(),
        "register":(context) => const Register(),
        "home":(context) => const Home(),
      },
    );
  }
}
