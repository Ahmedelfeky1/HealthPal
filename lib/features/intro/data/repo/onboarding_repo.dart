import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/features/intro/data/logic/onboarding_model.dart';

class OnboardingRepo {
  static List<OnboardingModel> getOnboardingData = [
    OnboardingModel(
      image: AppAssets.onboarding1,
      title: "Meet Doctors Online",
      description:
          "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
    ),
    OnboardingModel(
      image: AppAssets.onboarding2,
      title: "Connect with Specialists",
      description:
          "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
    ),
    OnboardingModel(
      image: AppAssets.onboarding3,
      title: "Thousands of Online Specialists",
      description:
          " Explore a Vast Array of Online Medical Specialists, Offering an Extensive Range of Expertise Tailored to Your Healthcare Needs.",
    ),
  ];
}
