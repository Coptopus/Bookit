import 'package:flutter/material.dart';

class ButtonAuth extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final void Function()? onPressed;
  const ButtonAuth({
    super.key,
    required this.label,
    this.color = const Color.fromARGB(255, 168, 185, 230),
    this.textColor = Colors.black,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: textColor,
      color: color,
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
