import 'package:doctor_appointment/core/helpers/location_helper.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_row_data.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/doctors/presentation/ui/nearby_doctors_screen.dart';
import 'package:doctor_appointment/features/home/presentation/widget/categories_home.dart';
import 'package:doctor_appointment/features/doctors/presentation/widget/nearby_doctors_section.dart';
import 'package:doctor_appointment/features/home/presentation/widget/home_bannar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location", style: TextStyles.font13GrayRegular),
            SizedBox(height: 3.h),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: ColorsManager.darkTeal,
                  size: 20,
                ),

                FutureBuilder<String>(
                  future: LocationHelper.getCurrentAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 15.w,
                        height: 15.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorsManager.darkTeal,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Location not found",
                        style: TextStyles.font13GrayRegular.copyWith(
                          color: ColorsManager.darkTeal,
                        ),
                      );
                    } else {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyles.font13GrayRegular.copyWith(
                          color: ColorsManager.darkTeal,
                        ),
                      );
                    }
                  },
                ),

                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: ColorsManager.darkTeal,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              CustomTextFormField(
                hintText: "Search doctor...",
                isReadOnly: true,
                hintStyle: TextStyles.font13GrayRegular.copyWith(fontSize: 15),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NearbyDoctorsScreen(),
                    ),
                  );
                },
                controller: searchController,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: ColorsManager.gray,
                    size: 40.h,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              HomeBannar(),
              SizedBox(height: 20.h),
              CustomRowData(
                text: "Categories",
                style: TextStyles.font18BlackBold.copyWith(
                  color: ColorsManager.darkBlue,
                  fontSize: 15.sp,
                ),
                textButton: "See All",
                btStyle: TextStyles.font14GrayBlack,
                screenName: Center(child: Text("All Categories")),
              ),
              SizedBox(height: 10.h),
              CategoriesHome(),
              SizedBox(height: 10.h),
              CustomRowData(
                text: "Nearby Doctors",
                style: TextStyles.font18BlackBold.copyWith(
                  color: ColorsManager.darkBlue,
                  fontSize: 15.sp,
                ),
                textButton: "See All",
                btStyle: TextStyles.font14GrayBlack,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NearbyDoctorsScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              NearbyDoctorsSection(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
