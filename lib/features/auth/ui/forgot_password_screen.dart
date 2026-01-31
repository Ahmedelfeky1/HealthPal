import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/core/widgets/custom_text_form_field.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:doctor_appointment/features/auth/logic/cubit/auth_cubit.dart';
import 'package:doctor_appointment/features/auth/ui/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: Form(
        key: formKey,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: ColorsManager.darkTeal,
                  ),
                ),
              );
            } else if (state is AuthCodeSent) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VerifyCodeScreen(email: emailController.text.trim()),
                ),
              );
            } else if (state is AuthError) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const Icon(Icons.error, color: Colors.red),
                  content: Text(state.error),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                SvgPicture.asset(AppAssets.logoBlack),
                SizedBox(height: 30.h),
                Text("Forget Password?", style: TextStyles.font18BlackBold),
                SizedBox(height: 8),
                Text(
                  "Enter your Email, we will send you a verification\n code.",
                  textAlign: TextAlign.center,
                  style: TextStyles.font13GrayRegular,
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Your Email",
                        controller: emailController,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: const Color.fromARGB(113, 107, 114, 128),
                        ),
                      ),
                      SizedBox(height: 50.h),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: "Send Code",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().sendResetCode(
                                  email: emailController.text.trim(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
