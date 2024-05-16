import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    double fontScale = MediaQuery.of(context).size.height / 900;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 18 * fontScale),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        fillColor: Colors.grey[300],
        filled: true,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 18 * fontScale),
        hintText: hintText,
      ),
    );
  }
}
