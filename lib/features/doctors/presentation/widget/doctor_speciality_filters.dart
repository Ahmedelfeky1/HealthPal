import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/home/data/models/category_model.dart';
import 'package:doctor_appointment/features/home/logic/category_cubit/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorSpecialityFilters extends StatefulWidget {
  const DoctorSpecialityFilters({super.key});

  @override
  State<DoctorSpecialityFilters> createState() =>
      _DoctorSpecialityFiltersState();
}

class _DoctorSpecialityFiltersState extends State<DoctorSpecialityFilters> {
  int selectedSpeciality = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccess) {
          final categories = [
            CategoryModel(id: 0, name: 'All', iconUrl: ''),
            ...state.categories,
          ];

          return SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSpeciality = index;
                    });
                    var specialityName = categories[index].name;
                    context.read<DoctorCubit>().filterDoctors(specialityName);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: selectedSpeciality == index
                          ? ColorsManager.darkTeal
                          : ColorsManager.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: ColorsManager.lightGray,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categories[index].name,
                      style: selectedSpeciality == index
                          ? TextStyles.font18BlackBold.copyWith(
                              color: ColorsManager.white,
                              fontSize: 12.sp,
                            )
                          : TextStyles.font18BlackBold.copyWith(
                              fontSize: 12.sp,
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
