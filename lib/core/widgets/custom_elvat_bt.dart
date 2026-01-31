import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w ?? double.infinity,
      height: height?.h ?? 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          //
          backgroundColor: backgroundColor ?? ColorsManager.darkTeal,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 16.r),
          ),

          elevation: 0,
        ),
        child: Text(
          text,
          style:
              textStyle ??
              TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
