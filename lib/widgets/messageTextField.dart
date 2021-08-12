import 'package:flutter/material.dart';
import 'package:jangle_app/styles.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  const MessageTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(
        fillColor: messageColor1,
        focusColor: messageColor1,
        hoverColor: messageColor1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        hintText: 'Type message ...',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      textInputAction: TextInputAction.done,
    );
  }
}
