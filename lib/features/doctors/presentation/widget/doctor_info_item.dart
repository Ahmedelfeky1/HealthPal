import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DoctorInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  const DoctorInfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          width: 50.w,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorsManager.gray50,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(icon, height: 10.h, width: 10.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyles.font14GrayBlack.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyles.font14GrayBlack.copyWith(fontSize: 13.sp),
        ),
      ],
    );
  }
}
