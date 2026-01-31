import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/doctors/presentation/ui/nearby_doctors_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class CategoriesHome extends StatelessWidget {
  CategoriesHome({super.key});

  List<Map<String, dynamic>> categories = [
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Dentistry.svg",
      'title': 'Dentist',
      'color': Color(0xffDC9497),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Cardiology.png",
      'title': 'Cardiologist',
      'color': Color(0xff93C19E),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Pulmonology.svg",
      'title': 'Pulmonology',
      'color': Color(0xffF5AD7E),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/General.png",
      'title': 'General',
      'color': Color(0xffACA1CD),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Neurology.svg",
      'title': 'Neurologist',
      'color': Color(0xff4D9B91),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Gastroenterology.svg",
      'title': 'Gastroenterology',
      'color': Color(0xff352261),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Laboratory.svg",
      'title': 'Laboratory',
      'color': Color(0xffDEB6B5),
    },
    {
      'url':
          "https://aybupaladobijimpsibf.supabase.co/storage/v1/object/public/category_icons/Vaccination.svg",
      'title': 'Vaccination',
      'color': Color(0xff89CCDB),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 1 / 1.3,
      ),
      itemBuilder: (context, index) {
        String url = categories[index]['url'];
        String title = categories[index]['title'];
        Color color = categories[index]['color'];
        bool isSvg = url.toLowerCase().endsWith('.svg');
        return GestureDetector(
          onTap: () {
            context.read<DoctorCubit>().filterDoctors(title);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NearbyDoctorsScreen()),
            );
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: isSvg
                        ? SvgPicture.network(
                            url,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            placeholderBuilder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.darkTeal,
                              ),
                            ),
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.darkTeal,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.font12WhiteRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.darkTeal,
                  fontSize: 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
