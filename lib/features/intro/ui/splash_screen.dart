import 'package:doctor_appointment/features/home/presentation/main_layout.dart';
import 'package:doctor_appointment/features/intro/ui/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.splashBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: SvgPicture.asset(AppAssets.logoWhite)),
      ),
    );
  }
}
