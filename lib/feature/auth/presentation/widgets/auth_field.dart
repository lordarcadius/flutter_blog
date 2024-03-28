import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinText;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField(
      {super.key,
      required this.hinText,
      required this.controller,
      this.isObscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(hintText: hinText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hinText can't be empty";
        }
        return null;
      },
    );
  }
}
