import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:doctor_appointment/features/auth/logic/cubit/auth_cubit.dart';
import 'package:doctor_appointment/features/auth/ui/new_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController pinController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(AuthService()),
        child: BlocConsumer<AuthCubit, AuthState>(
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
            } else if (state is AuthSuccess) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NewPasswordScreen()),
              );
            } else if (state is AuthCodeSent) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Code sent successfully! Check your email."),
                  backgroundColor: ColorsManager.successGreen,
                ),
              );
            } else if (state is AuthError) {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const Icon(Icons.error, color: Colors.red),
                  content: Text(state.error, textAlign: TextAlign.center),
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  SvgPicture.asset(AppAssets.logoBlack),
                  SizedBox(height: 30.h),
                  Text("Verify Code", style: TextStyles.font18BlackBold),
                  SizedBox(height: 8.h),
                  Text(
                    "Enter the the code\n we just sent you on your registered Email",
                    textAlign: TextAlign.center,
                    style: TextStyles.font13GrayRegular,
                  ),
                  SizedBox(height: 30),
                  Pinput(
                    length: 5,
                    showCursor: true,
                    controller: pinController,
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Please enter the full code';
                      }
                      return null;
                    },
                    defaultPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.h,
                      textStyle: TextStyles.font24BlackBold,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(68, 107, 114, 128),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorsManager.lighterGray),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50.w,
                      height: 50.h,
                      textStyle: TextStyles.font24BlackBold,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorsManager.darkTeal),
                      ),
                    ),
                    onCompleted: (pin) {},
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Verify",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (pinController.text.length == 5) {
                            context.read<AuthCubit>().verifyCode(
                              email: widget.email,
                              code: pinController.text,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code?",
                        style: TextStyles.font13GrayRegular,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().sendResetCode(
                            email: widget.email,
                          );
                        },
                        child: Text(
                          "Resend",
                          style: TextStyles.font13GrayRegular.copyWith(
                            color: ColorsManager.mainBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
