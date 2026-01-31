import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DoctorReviewItem extends StatelessWidget {
  const DoctorReviewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ColorsManager.gray50,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(AppAssets.personRev),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emily Anderson",
                  style: TextStyles.font14GrayBlack.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.darkTeal,
                  ),
                ),
                Row(
                  children: [
                    Text("5"),
                    SizedBox(width: 8.w),
                    Icon(Icons.star, color: ColorsManager.starOrange),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          "Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.",
          style: TextStyles.font14GrayBlack,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
