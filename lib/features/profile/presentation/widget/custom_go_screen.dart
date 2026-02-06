import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CustomGoScreen extends StatelessWidget {
  String iconSvg;
  String title;
  void Function()? onTap;
  CustomGoScreen({
    super.key,
    required this.iconSvg,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 5),
          Row(
            children: [
              SvgPicture.asset(
                iconSvg,
                height: 22.h,
                color: ColorsManager.darkTeal,
              ),
              SizedBox(width: 5.h),
              Text(
                title,
                style: TextStyles.font18BlackBold.copyWith(
                  color: ColorsManager.gray,
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: ColorsManager.gray,
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(color: ColorsManager.lighterGray, thickness: 1),
        ],
      ),
    );
  }
}
