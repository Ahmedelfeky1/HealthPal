import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/reviews/data/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DoctorReviewItem extends StatelessWidget {
  final ReviewModel reviewModel;
  const DoctorReviewItem({super.key, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorsManager.gray50,
                  shape: BoxShape.circle,
                  image:
                      reviewModel.userImage != null &&
                          reviewModel.userImage!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(reviewModel.userImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child:
                    reviewModel.userImage == null ||
                        reviewModel.userImage!.isEmpty
                    ? Center(
                        child: Text(
                          reviewModel.userName.isNotEmpty
                              ? reviewModel.userName[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: ColorsManager.darkTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewModel.userName,
                    style: TextStyles.font14GrayBlack.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.darkTeal,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        reviewModel.rating.toString(),
                        style: TextStyles.font14GrayBlack,
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.star, color: ColorsManager.starOrange),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              reviewModel.comment.isEmpty ? 'No comment' : reviewModel.comment,
              style: TextStyles.font14GrayBlack,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
