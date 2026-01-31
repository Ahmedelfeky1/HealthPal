import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/nearby_doctors_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchDocScreen extends StatelessWidget {
  const SearchDocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image(image: AssetImage(AppAssets.mapBg), fit: BoxFit.cover),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: CustomTextFormField(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search Doctors",
                  onChanged: (value) {},
                  backgroundColor: ColorsManager.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: NearbyDoctorsSection(),
            ),
          ),
        ],
      ),
    );
  }
}
