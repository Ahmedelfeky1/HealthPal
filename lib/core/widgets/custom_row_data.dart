import 'package:flutter/material.dart';

class CustomRowData extends StatelessWidget {
  const CustomRowData({
    super.key,
    required this.text,
    required this.textButton,
    this.screenName,
    this.onPressed,
    this.style,
    this.btStyle,
    this.color,
  });

  final String text;
  final Widget? screenName;

  final void Function()? onPressed;
  final String textButton;
  final Color? color;
  final TextStyle? style;
  final TextStyle? btStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style:
              style ??
              TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
        ),
        const Spacer(),
        TextButton(
          onPressed:
              onPressed ??
              () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => screenName!),
                );
              },
          child: Text(
            textButton,
            style:
                btStyle ??
                TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
