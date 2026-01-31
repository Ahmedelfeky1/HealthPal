import 'package:doctor_appointment/core/helpers/location_helper.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/favorite_icon.dart';
import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_appointment/features/doctors/presentation/ui/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorListTile extends StatelessWidget {
  const DoctorListTile({super.key, required this.doctorModel});

  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(doctorModel),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: ColorsManager.white,
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image(
                image: NetworkImage(doctorModel.imageUrl),
                fit: BoxFit.cover,
                height: 120.h,
                width: 110.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        doctorModel.name,
                        style: TextStyles.font18BlackBold.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      Spacer(),
                      FavoriteIcon(doctorId: doctorModel.id),
                    ],
                  ),
                  Divider(),
                  Text(
                    doctorModel.specialty,
                    style: TextStyles.font18BlackBold.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 5.h),

                  GestureDetector(
                    onTap: () {
                      if (doctorModel.latitude != null &&
                          doctorModel.longitude != null) {
                        LocationHelper.openMap(
                          doctorModel.latitude!,
                          doctorModel.longitude!,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Location not available for this doctor",
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 20.sp),
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            doctorModel.address,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: ColorsManager.starOrange,
                        size: 20.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(doctorModel.reviewsCount.toString()),
                      SizedBox(width: 5.w),
                      Text("|"),
                      SizedBox(width: 5.w),
                      Text("${doctorModel.rating.toString()} Reviews"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
