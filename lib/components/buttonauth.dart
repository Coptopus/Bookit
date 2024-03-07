import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  const ButtonAuth({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: const Color.fromARGB(255, 168, 185, 230),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      height: 50,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
