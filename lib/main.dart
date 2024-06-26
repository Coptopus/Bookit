import 'package:bookit/auth/login.dart';
import 'package:bookit/firebase_options.dart';
import 'package:bookit/pages/home.dart';
import 'package:bookit/pages/profile.dart';
import 'package:bookit/services/add.dart';
import 'package:bookit/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import './model/cart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return Cart();
    },
    child: MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            surfaceTint: Colors.white,
            primary: Colors.black,
          ),
          // primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 5,
              shadowColor: Colors.black)),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const Home()
          : const Login(),
      routes: {
        "welcome": (context) => const Welcome(),
        "login": (context) => const Login(),
        "home": (context) => const Home(),
        "profile": (context) => const Profile(),
        "addServ": (context) => const AddService(),
      },
    ),
    );
  }
}
