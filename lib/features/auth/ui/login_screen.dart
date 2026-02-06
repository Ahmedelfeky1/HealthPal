import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_row_data.dart';
import 'package:doctor_appointment/core/widgets/custom_text_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/core/widgets/social_login_button.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:doctor_appointment/features/auth/logic/cubit/auth_cubit.dart';
import 'package:doctor_appointment/features/auth/ui/forgot_password_screen.dart';
import 'package:doctor_appointment/features/auth/ui/signup_screen.dart';
import 'package:doctor_appointment/features/home/presentation/main_layout.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/fill_profile_screen.dart';
import 'package:doctor_appointment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final bool isObscureText = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.darkTeal),
              ),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
            final isComplete = await AuthService().isUserCompletedProfile();
            if (context.mounted) {
              if (isComplete) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainLayout()),
                );
              } else {
                final user = supabase.auth.currentUser;
                final firstName = user?.userMetadata?['full_name'] ?? '';
                final email = user?.email ?? '';
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FillProfileScreen(firstName: firstName, email: email),
                  ),
                );
              }
            }
          } else if (state is AuthError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 70.h),
                    SvgPicture.asset(AppAssets.logoBlack),
                    SizedBox(height: 32.h),
                    Text(
                      "Hi, Welcome Back! ",
                      style: TextStyles.font18BlackBold,
                    ),
                    Text(
                      "Hope you’re doing fine.",
                      style: TextStyles.font13GrayRegular,
                    ),
                    SizedBox(height: 32.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomTextFormField(
                              hintText: "Your Email",
                              controller: emailController,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: ColorsManager.gray,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            CustomTextFormField(
                              controller: passwordController,
                              hintText: "Password",
                              isObscureText: true,
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: ColorsManager.gray,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'Sign In',
                              borderRadius: 30.r,
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: ColorsManager.lightGray,
                                  ),
                                ),
                                Text(
                                  "  or  ",
                                  style: TextStyles.font13GrayRegular,
                                ),
                                Expanded(
                                  child: Divider(
                                    color: ColorsManager.lightGray,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            SocialLoginButton(
                              text: "Sign in with Google",
                              onPressed: () async {
                                try {
                                  await AuthService().signInWithGoogle();
                                  final isComplete = await AuthService()
                                      .isUserCompletedProfile();
                                  if (context.mounted) {
                                    if (isComplete) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainLayout(),
                                        ),
                                      );
                                    } else {
                                      final user = supabase.auth.currentUser;
                                      final firstName =
                                          user?.userMetadata?['full_name'] ??
                                          '';
                                      final email = user?.email ?? '';
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FillProfileScreen(
                                                firstName: firstName,
                                                email: email,
                                              ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to login with Google ${e.toString()}",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              iconPath: AppAssets.googleLogo,
                            ),
                            SizedBox(height: 10.h),
                            SocialLoginButton(
                              text: "Sign In with Facebook",
                              onPressed: () async {
                                try {
                                  await AuthService().signInWithFacebook();
                                  final isComplete = await AuthService()
                                      .isUserCompletedProfile();
                                  if (context.mounted) {
                                    if (isComplete) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainLayout(),
                                        ),
                                      );
                                    } else {
                                      final user = supabase.auth.currentUser;
                                      final firstName =
                                          user?.userMetadata?['full_name'] ??
                                          '';
                                      final email = user?.email ?? '';
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FillProfileScreen(
                                                firstName: firstName,
                                                email: email,
                                              ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Failed to login with Facebook ${e.toString()}",
                                      ),
                                    ),
                                  );
                                }
                              },
                              iconPath: AppAssets.facebookLogo,
                            ),
                            SizedBox(height: 10.h),
                            CustomTextBt(
                              text: "Forgot password?",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              colorText: ColorsManager.mainBlue,
                              fontSize: 14.sp,
                            ),
                            SizedBox(height: 20.h),
                            CustomRowData(
                              text: "Don’t have an account yet? ",
                              textButton: "Sign Up",
                              color: ColorsManager.mainBlue,
                              screenName: SignupScreen(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
