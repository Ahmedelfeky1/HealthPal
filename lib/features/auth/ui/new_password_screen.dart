import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:doctor_appointment/features/auth/logic/cubit/auth_cubit.dart';
import 'package:doctor_appointment/features/auth/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
              MaterialPageRoute(builder: (context) => LoginScreen()),
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
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    SvgPicture.asset(AppAssets.logoBlack),
                    SizedBox(height: 30),
                    Text(
                      "Create new password",
                      style: TextStyles.font18BlackBold,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      textAlign: TextAlign.center,
                      "Your new password must be different\n form previously used password",
                      style: TextStyles.font13GrayRegular,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            hintText: "Password",
                            controller: passwordController,
                            isObscureText: true,
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: ColorsManager.gray,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextFormField(
                            hintText: "Confirm Password",
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return "Password doesn't match";
                              }
                              return null;
                            },
                            isObscureText: true,
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: ColorsManager.gray,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          CustomButton(
                            text: "Reset Password",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().updatePassword(
                                  newPassword: passwordController.text,
                                );
                              }
                            },
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
