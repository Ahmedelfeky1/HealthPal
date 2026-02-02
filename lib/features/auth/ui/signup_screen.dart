import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_row_data.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/core/widgets/social_login_button.dart';
import 'package:doctor_appointment/features/auth/data/models/signup_model.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:doctor_appointment/features/auth/logic/cubit/auth_cubit.dart';
import 'package:doctor_appointment/features/auth/ui/login_screen.dart';
import 'package:doctor_appointment/features/home/presentation/main_layout.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/fill_profile_screen.dart';
import 'package:doctor_appointment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.darkTeal),
              ),
            );
          } else if (state is AuthSuccess) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FillProfileScreen(
                  firstName: nameController.text.trim(),
                  email: emailController.text.trim(),
                ),
              ),
            );
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
                    SizedBox(height: 20.h),
                    Text("Create Account", style: TextStyles.font18BlackBold),
                    SizedBox(height: 5.h),
                    Text(
                      "We are here to help you!",
                      style: TextStyles.font13GrayRegular,
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            hintText: "Your Name",
                            controller: nameController,
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: const Color.fromARGB(114, 107, 114, 128),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            hintText: "Your Email",
                            controller: emailController,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: const Color.fromARGB(114, 107, 114, 128),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          CustomTextFormField(
                            hintText: "Your Phone",
                            controller: phoneController,
                            prefixIcon: Icon(
                              Icons.phone,
                              color: const Color.fromARGB(114, 107, 114, 128),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextFormField(
                            hintText: "Your Password",
                            isObscureText: true,
                            controller: passwordController,
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: const Color.fromARGB(114, 107, 114, 128),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            text: "Create Account",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final SignupModel signupModel = SignupModel(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  name: nameController.text.trim(),
                                  phone: phoneController.text,
                                );
                                context.read<AuthCubit>().signup(signupModel);
                              }
                            },
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: ColorsManager.lightGray),
                              ),
                              Text(
                                "  or  ",
                                style: TextStyles.font13GrayRegular,
                              ),
                              Expanded(
                                child: Divider(color: ColorsManager.lightGray),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SocialLoginButton(
                            iconPath: AppAssets.googleLogo,
                            text: "Continue with Google",
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
                                        user?.userMetadata?['full_name'] ?? '';
                                    final email = user?.email ?? '';
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FillProfileScreen(
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
                          ),
                          SizedBox(height: 5.h),
                          SocialLoginButton(
                            iconPath: AppAssets.facebookLogo,
                            text: "Continue with Facebook",
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
                                        user?.userMetadata?['full_name'] ?? '';
                                    final email = user?.email ?? '';
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FillProfileScreen(
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
                          ),
                          CustomRowData(
                            text: "Do you have an account ? ",
                            textButton: "Sign In",
                            color: ColorsManager.mainBlue,
                            screenName: LoginScreen(),
                          ),
                        ],
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
