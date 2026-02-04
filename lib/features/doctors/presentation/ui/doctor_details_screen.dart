import 'dart:convert';

import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_row_data.dart';
import 'package:doctor_appointment/core/widgets/favorite_icon.dart';
import 'package:doctor_appointment/features/booking/data/repo/booking_repo.dart';
import 'package:doctor_appointment/features/booking/data/service/booking_service.dart';
import 'package:doctor_appointment/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:doctor_appointment/features/booking/presentation/ui/booking_screen.dart';
import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/doctor_info_item.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/doctor_review_item.dart';
import 'package:doctor_appointment/features/reviews/presentation/ui/reviews_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final DoctorModel doctorModel;
  DoctorDetailsScreen(this.doctorModel, {super.key});

  late final List<Map<String, dynamic>> doctorInfoData = [
    {
      'icon': AppAssets.personIcon,
      'value': doctorModel.patients,
      'title': 'patients',
    },
    {
      'icon': AppAssets.medalIcon,
      'value': "${doctorModel.experience}+",
      'title': 'experience',
    },
    {
      'icon': AppAssets.starIcon,
      'value': doctorModel.rating,
      'title': 'rating',
    },
    {
      'icon': AppAssets.messIcon,
      'value': doctorModel.reviewsCount,
      'title': 'reviews',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Doctor Details", style: TextStyles.font18BlackBold),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FavoriteIcon(doctorId: doctorModel.id),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  border: Border.all(color: ColorsManager.gray50, width: 1),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 8,
                      offset: const Offset(1, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(16.r),
                        ),
                        child: Image(
                          image: NetworkImage(doctorModel.imageUrl),
                          width: 110.w,
                          height: 110.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorModel.name,
                              style: TextStyles.font18BlackBold,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Divider(color: ColorsManager.lightGray),
                            SizedBox(height: 4.h),
                            Text(
                              doctorModel.specialty,
                              style: TextStyles.font14GrayBlack.copyWith(
                                color: ColorsManager.darkTeal,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: ColorsManager.darkTeal,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    doctorModel.address,
                                    style: TextStyles.font14GrayBlack.copyWith(
                                      color: ColorsManager.darkTeal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: doctorInfoData.map((item) {
                  return DoctorInfoItem(
                    title: item["title"],
                    value: item["value"].toString(),
                    icon: item["icon"],
                  );
                }).toList(),
              ),

              SizedBox(height: 15.h),
              Text("About me", style: TextStyles.font18BlackBold),
              SizedBox(height: 10.h),
              ReadMoreText(
                doctorModel.about ??
                    "There is no details about this doctor yet.",
                style: TextStyles.font14GrayBlack,
                trimLines: 3,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' View more',
                trimExpandedText: ' View less',
                moreStyle: TextStyles.font14GrayBlack.copyWith(
                  color: ColorsManager.darkTeal,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                lessStyle: TextStyles.font14GrayBlack.copyWith(
                  color: ColorsManager.darkTeal,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),

              SizedBox(height: 15.h),
              Text("Working Time", style: TextStyles.font18BlackBold),
              SizedBox(height: 10.h),
              Text(
                doctorModel.workingHours ??
                    "There is no details about this doctor yet.",
              ),
              SizedBox(height: 15.h),
              CustomRowData(
                text: "Reviews",
                style: TextStyles.font18BlackBold,
                textButton: "See All",
                screenName: ReviewsDoctorScreen(doctorId: doctorModel.id),
                btStyle: TextStyles.font13GrayRegular,
              ),
              SizedBox(height: 10.h),
              DoctorReviewItem(),
              SizedBox(height: 15.h),
              CustomButton(
                text: "Book Appointment",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) {
                          final service = BookingService();
                          final repo = BookingRepo(bookingService: service);
                          return BookingCubit(repo);
                        },
                        child: BookingScreen(doctorModel: doctorModel),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
