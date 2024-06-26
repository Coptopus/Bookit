import 'package:flutter/material.dart';

class LogoAuth extends StatelessWidget {
  const LogoAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      height: 100,
      child: Image.asset(
        'assets/BookitTitle.png',
        fit: BoxFit.fill,
      ),
    );
  }
}

Widget appTitle = SizedBox(
    height: 45,
    child: Image.asset(
      'assets/BookitTitle.png',
      fit: BoxFit.fitHeight,
    ));