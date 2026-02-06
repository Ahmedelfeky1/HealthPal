import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/features/auth/ui/login_screen.dart';
import 'package:doctor_appointment/features/intro/data/logic/onboarding_model.dart';
import 'package:doctor_appointment/features/intro/data/repo/onboarding_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

final List<OnboardingModel> pages = OnboardingRepo.getOnboardingData;
final PageController pageController = PageController();

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(
                      pages[index].image,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Column(
                        children: [
                          Text(
                            pages[index].title,
                            style: TextStyles.font18BlackBold,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            pages[index].description,
                            style: TextStyles.font14GrayBlack,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: [
                CustomButton(
                  text: "Next",
                  onPressed: () {
                    if (currentIndex < pages.length - 1) {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  height: 40,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 5.w),
                      width: currentIndex == index ? 30.w : 10.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? ColorsManager.darkTeal
                            : ColorsManager.lightGray,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("Skip", style: TextStyles.font14GrayBlack),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
