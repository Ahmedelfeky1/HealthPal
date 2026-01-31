import 'package:flutter/material.dart';
// ignore: must_be_immutable
class CustomTextBt extends StatelessWidget {
  CustomTextBt({
    super.key,
    required this.text,
    required this.onPressed,
    this.myDecoration,
    required this.colorText,
    required this.fontSize,
    this.decorationColor,
  });

  final String text;
  final Function() onPressed;
  TextDecoration? myDecoration;
  final Color colorText;
  final double fontSize;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: colorText,
          decoration: myDecoration,
          decorationColor: decorationColor,
        ),
      ),
    );
  }
}
