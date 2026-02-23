import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/doctor_profile/data/models/doctor_info_model.dart';
import 'package:doctor_appointment/features/doctor_profile/data/services/doctor_info_services.dart';
import 'package:doctor_appointment/features/doctor_profile/logic/cubit/doctorprofile_cubit.dart';
import 'package:doctor_appointment/features/doctor_profile/presentation/widget/custom_dropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDataScreen extends StatefulWidget {
  const DoctorDataScreen({super.key});

  @override
  State<DoctorDataScreen> createState() => _DoctorDataScreenState();
}

class _DoctorDataScreenState extends State<DoctorDataScreen> {
  double? latitude;
  double? longitude;

  final TextEditingController priceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController workingHoursController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  String? selectedSpecialty;

  @override
  void dispose() {
    priceController.dispose();
    bioController.dispose();
    phoneController.dispose();
    workingHoursController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorprofileCubit(DoctorInfoServices())..getDoctorProfile(),
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        appBar: AppBar(
          backgroundColor: ColorsManager.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text("Doctor info", style: TextStyles.font18BlackBold),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsManager.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocConsumer<DoctorprofileCubit, DoctorprofileState>(
          listener: (context, state) {
            if (state is DoctorprofileUpdating) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.darkTeal,
                  ),
                ),
              );
            } else if (state is DoctorprofileSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile updated successfully"),
                  backgroundColor: ColorsManager.successGreen,
                ),
              );
              Navigator.pop(context);
            } else if (state is DoctorprofileError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: ColorsManager.errorRed,
                ),
              );
            } else if (state is DoctorprofileLoading) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.darkTeal,
                  ),
                ),
              );
            } else if (state is DoctorprofileLoaded) {
              final data = state.doctorData;
              priceController.text = data.price.toString();
              bioController.text = data.about;
              phoneController.text = data.phone;
              workingHoursController.text = data.workingHours;
              addressController.text = data.address;
              setState(() {
                selectedSpecialty = data.specialty;
                latitude = data.latitude;
                longitude = data.longitude;
              });
            }
          },
          builder: (context, state) {
            if (state is DoctorprofileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorsManager.darkTeal),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: fromKey,
                  child: Column(
                    children: [
                      CustomDropdown(
                        value: selectedSpecialty,
                        onChanged: (newValue) {
                          setState(() {
                            selectedSpecialty = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select Specialty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Price", style: TextStyles.font14GrayBlack),
                      ),
                      SizedBox(height: 3.h),
                      CustomTextFormField(
                        controller: priceController,
                        prefixIcon: Icon(
                          Icons.attach_money_outlined,
                          color: ColorsManager.darkTeal,
                        ),
                        hintText: 'e.g 200',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        backgroundColor: ColorsManager.gray50,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("About", style: TextStyles.font14GrayBlack),
                      ),
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: bioController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter About yourself';
                          }
                          return null;
                        },
                        hintText: "Dr......",
                        maxLines: 5,
                        backgroundColor: ColorsManager.moreLightGray,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phone Number",
                          style: TextStyles.font14GrayBlack,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        hintText: '+201 000 0000',
                        keyboardType: TextInputType.phone,
                        backgroundColor: ColorsManager.moreLightGray,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Working Time",
                          style: TextStyles.font14GrayBlack,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: workingHoursController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter working hours';
                          }
                        },
                        hintText: 'Monday-Friday, 08.00 AM-18.00 pM',
                        backgroundColor: ColorsManager.moreLightGray,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorsManager.lighterGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Clinic Location",
                          style: TextStyles.font14GrayBlack,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: latitude != null
                              ? ColorsManager.successGreen.withOpacity(0.05)
                              : ColorsManager.moreLightGray,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: latitude != null
                                ? ColorsManager.successGreen
                                : ColorsManager.lighterGray,
                            width: 1.3,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            onTap: () async {
                              setState(() {
                                latitude = 30.0;
                                longitude = 31.0;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 18.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    latitude != null
                                        ? Icons.check_circle
                                        : Icons.location_on_rounded,
                                    color: latitude != null
                                        ? ColorsManager.successGreen
                                        : ColorsManager.darkTeal,
                                    size: 24.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    latitude != null
                                        ? "Location Selected"
                                        : "Pin Location on Map",
                                    style: TextStyle(
                                      color: latitude != null
                                          ? ColorsManager.successGreen
                                          : ColorsManager.lightGray,
                                      fontSize: 14.sp,
                                      fontWeight: latitude != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (latitude != null)
                                    Icon(
                                      Icons.edit,
                                      color: ColorsManager.successGreen,
                                      size: 18.sp,
                                    )
                                  else
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorsManager.lightGray,
                                      size: 16.sp,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        hintText: "Detailed Address (e.g. Floor 3, Building 5)",
                        maxLines: 2,
                      ),
                      SizedBox(height: 40.h),
                      Builder(
                        builder: (context) {
                          return CustomButton(
                            text: "Save information",
                            onPressed: () {
                              if (fromKey.currentState!.validate()) {
                                if (latitude == null || longitude == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select location"),
                                    ),
                                  );
                                  return;
                                }
                                final doctorData = DoctorInfoModel(
                                  specialty: selectedSpecialty!,
                                  price: int.parse(priceController.text),
                                  about: bioController.text,
                                  workingHours: workingHoursController.text,
                                  address: addressController.text,
                                  latitude: latitude!,
                                  longitude: longitude!,
                                  phone: phoneController.text,
                                );
                                context
                                    .read<DoctorprofileCubit>()
                                    .saveDoctorProfile(doctorData);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
