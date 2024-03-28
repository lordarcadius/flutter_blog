import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinText;
  const AuthField({super.key, required this.hinText});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      decoration: InputDecoration(
        hintText: hinText
      ),
    );
  }
}