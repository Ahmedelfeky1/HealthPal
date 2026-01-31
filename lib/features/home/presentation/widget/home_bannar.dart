import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBannar extends StatefulWidget {
  const HomeBannar({super.key});

  @override
  State<HomeBannar> createState() => _HomeBannarState();
}

final List<Map<String, dynamic>> banners = [
  {
    'title': 'Book and\nschedule with\nnearest doctor',
    'description': 'Book and schedule\nwith nearest doctor',
    'image': AppAssets.bannarDoc1,
    'textColor': ColorsManager.moreLightGray,
  },
  {
    'title': 'Looking for\nSpecialist Doctors?',
    'description': 'Schedule an appointment with\nyour top doctors.',
    'image': AppAssets.bannarDoc2,
    'textColor': ColorsManager.moreLightGray,
  },
  {
    'title': 'Check your\nhealth status\nnow!',
    'description': 'Book and schedule\nwith nearest doctor',
    'image': AppAssets.bannarDoc3,
    'textColor': ColorsManager.darkTeal,
  },
  {
    'title': 'Get 20% Off on\nyour first\nappointment',
    'description': 'Book and schedule\nwith nearest doctor',
    'image': AppAssets.bannarDoc4,
    'textColor': ColorsManager.darkTeal,
  },
];

class _HomeBannarState extends State<HomeBannar> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160.h,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 160.h,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
            items: banners.map((banner) {
              return _buildBannerItem(
                title: banner['title'],
                description: banner['description'] as String,
                imagePath: banner['image'] as String,
                textColor: banner['textColor'],
              );
            }).toList(),
          ),
          Positioned(
            bottom: 15.h,
            left: 130.w,
            child: Row(
              children: banners.asMap().entries.map((entry) {
                bool isActive = activeIndex == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 25.w : 10.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem({
    required String title,
    required String description,
    required String imagePath,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.font18WhiteMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyles.font12WhiteRegular.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
