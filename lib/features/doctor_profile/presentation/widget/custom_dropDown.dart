import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> specialtiesList = [
    'General',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Pediatrics',
    'Gynecology',
    'Dermatology',
    'Ophthalmology',
    'Dentistry',
    'Urology',
  ];
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Specialty"),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: value,
                dropdownColor: ColorsManager.white,
                items: specialtiesList.map((String specialty) {
                  return DropdownMenuItem<String>(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: onChanged,
                validator: validator,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorsManager.darkBlue,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsManager.lighterGray,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsManager.lighterGray,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.3),
                    borderRadius: BorderRadius.circular(16.0),
                  ),

                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.3),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  hintText: 'Select Specialty',
                  hintStyle: TextStyles.font14GrayBlack,
                  fillColor: ColorsManager.moreLightGray,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
