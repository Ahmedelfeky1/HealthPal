import 'package:doctor_appointment/core/helpers/location_helper.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/favorite_icon.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/doctors/presentation/ui/doctor_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearbyDoctorsSection extends StatelessWidget {
  const NearbyDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorCubit, DoctorState>(
      builder: (context, state) {
        if (state is DoctorsLoading) {
          return Center(
            child: CircularProgressIndicator(color: ColorsManager.darkTeal),
          );
        } else if (state is DoctorsError) {
          return Center(child: Text(state.error));
        } else if (state is DoctorsSuccess) {
          final doctors = state.doctors;

          return SizedBox(
            height: 240.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final doctorModel = state.doctors[index];
                final userPosition = context.read<DoctorCubit>().userPosition;
                String distanceText = '';
                if (userPosition != null &&
                    doctorModel.latitude != null &&
                    doctorModel.longitude != null) {
                  double distance = LocationHelper.calculateDistanceInKm(
                    userPosition.latitude,
                    userPosition.longitude,
                    doctorModel.latitude!,
                    doctorModel.longitude!,
                  );
                  distanceText = "$distance km";
                }
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
                    width: 210.w,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 110.h,
                                width: double.infinity,
                                child: Image(
                                  image: NetworkImage(doctors[index].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorsManager.lighterGray,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: FavoriteIcon(
                                    doctorId: doctors[index].id,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h),
                              Text(
                                doctors[index].name,
                                style: TextStyles.font18BlackBold.copyWith(
                                  color: ColorsManager.darkTeal,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              GestureDetector(
                                onTap: () {
                                  if (doctorModel.latitude != null &&
                                      doctorModel.longitude != null) {
                                    LocationHelper.openMap(
                                      doctorModel.latitude!,
                                      doctorModel.longitude!,
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined),
                                    Text(
                                      doctors[index].address,
                                      style: TextStyles.font12WhiteRegular
                                          .copyWith(
                                            color: ColorsManager.darkTeal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: ColorsManager.starOrange,
                                  ),
                                  Text(
                                    doctors[index].rating.toString(),
                                    style: TextStyles.font12WhiteRegular
                                        .copyWith(
                                          color: ColorsManager.darkTeal,
                                        ),
                                  ),
                                  Text(
                                    "${doctors[index].reviewsCount} Reviews",
                                    style: TextStyles.font12WhiteRegular
                                        .copyWith(
                                          color: ColorsManager.darkTeal,
                                        ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "Price :",
                                    style: TextStyles.font14GrayBlack,
                                  ),
                                  Expanded(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      "${doctors[index].price} EG",
                                      style: TextStyles.font14GrayBlack
                                          .copyWith(
                                            color: ColorsManager.darkTeal,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    " |$distanceText",
                                    style: TextStyles.font14GrayBlack,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
