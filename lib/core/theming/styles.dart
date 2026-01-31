import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle font24BlackBold = GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );
  static TextStyle font18BlackBold = GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );

  static TextStyle font32BlueBold = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.blue,
  );

  static TextStyle font13GrayRegular = GoogleFonts.inter(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: Colors.grey,
  );
  static TextStyle font14GrayBlack = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color.fromARGB(255, 67, 67, 67),
  );

  static TextStyle font16WhiteSemiBold = GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );
  static TextStyle font18WhiteMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle font12WhiteRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}
