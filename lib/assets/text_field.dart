import 'package:flutter/material.dart';
// import 'package:pay_or_save/utilities/validator.dart';

class CustomTextField extends StatelessWidget {
  final String newlabelText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboard;
  final Function(String) validator;

  const CustomTextField(
      {Key key,
      this.newlabelText,
      @required this.obscureText,
      this.controller,
      this.keyboard,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.2),
        labelText: newlabelText,
        labelStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.black),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboard,
    );
  }
}
