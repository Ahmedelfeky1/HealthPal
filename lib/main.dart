import 'package:doctor_appointment/features/doctors/data/services/doctors_services.dart';
import 'package:doctor_appointment/features/doctors/logic/doctors_cubit/doctor_cubit.dart';
import 'package:doctor_appointment/features/fovorites/data/services/favorites_service.dart';
import 'package:doctor_appointment/features/fovorites/logic/cubit/favorites_cubit.dart';
import 'package:doctor_appointment/features/home/data/services/category_service.dart';
import 'package:doctor_appointment/features/home/logic/category_cubit/cubit/category_cubit.dart';
import 'package:doctor_appointment/features/intro/ui/splash_screen.dart';
import 'package:doctor_appointment/features/profile/data/services/profile_service.dart';
import 'package:doctor_appointment/features/profile/logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/constants/app_constants.dart';

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const HealthPalApp(),
    ),
  );
}

class HealthPalApp extends StatelessWidget {
  const HealthPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DoctorCubit(DoctorsServices(supabase))..getDoctors(),
          ),
          BlocProvider(
            create: (context) =>
                CategoryCubit(CategoryService(Supabase.instance.client))
                  ..getCategories(),
          ),
          BlocProvider(
            create: (context) =>
                FavoritesCubit(FavoritesService())..getFavorites(),
          ),
          BlocProvider(
            create: (context) =>
                ProfileCubit(ProfileService())..getUserProfile(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HealthPal',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
