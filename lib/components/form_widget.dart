import 'package:flutter/material.dart';

class NormalForm extends StatelessWidget {
  final bool obsecureText;
  final String label;
  final String prefixText;
  final IconData suffixIcon;
  final TextEditingController controller;

  const NormalForm({
    super.key,
    required this.label,
    this.prefixText = '',
    required this.suffixIcon,
    required this.controller,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
        prefixText: prefixText,
        suffixIcon: Icon(suffixIcon, color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
