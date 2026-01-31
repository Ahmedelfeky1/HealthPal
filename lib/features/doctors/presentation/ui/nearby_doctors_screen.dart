import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/doctor_list_tile.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/doctor_speciality_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearbyDoctorsScreen extends StatelessWidget {
  const NearbyDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.read<DoctorCubit>().filterDoctors("All");

        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        appBar: AppBar(
          backgroundColor: ColorsManager.white,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text("Nearby Doctors", style: TextStyles.font18BlackBold),
          leading: IconButton(
            onPressed: () {
              context.read<DoctorCubit>().filterDoctors("All");
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                CustomTextFormField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.search, size: 30.sp),
                  ),
                  hintText: "Search Doctors",
                  onChanged: (value) {
                    context.read<DoctorCubit>().searchDoctors(value);
                  },
                ),
                SizedBox(height: 10.h),
                DoctorSpecialityFilters(),
                SizedBox(height: 20.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        await context.read<DoctorCubit>().getDoctors(),
                    color: ColorsManager.darkTeal,
                    child: BlocBuilder<DoctorCubit, DoctorState>(
                      builder: (context, state) {
                        if (state is DoctorsLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.darkTeal,
                            ),
                          );
                        } else if (state is DoctorsSuccess) {
                          return ListView.builder(
                            itemCount: state.doctors.length,
                            itemBuilder: (context, index) {
                              return DoctorListTile(
                                doctorModel: state.doctors[index],
                              );
                            },
                          );
                        } else if (state is DoctorsError) {
                          return Center(child: Text(state.error));
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off,
                                size: 50.sp,
                                color: Colors.grey,
                              ),
                              Text(
                                "No Doctors Found",
                                style: TextStyles.font14GrayBlack,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
