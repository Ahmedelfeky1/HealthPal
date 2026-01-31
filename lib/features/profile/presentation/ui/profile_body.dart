import 'package:doctor_appointment/core/constants/app_assets.dart';
import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/auth/ui/login_screen.dart';
import 'package:doctor_appointment/features/fovorites/ui/favorites_screen.dart';
import 'package:doctor_appointment/features/notifications/ui/notification_screen.dart';
import 'package:doctor_appointment/features/profile/logic/cubit/profile_cubit.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/fill_profile_screen.dart';
import 'package:doctor_appointment/features/profile/presentation/widget/custom_go_screen.dart';
import 'package:doctor_appointment/features/profile/presentation/widget/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        backgroundColor: ColorsManager.white,
        title: Text("Profile", style: TextStyles.font18BlackBold),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.darkBlue),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.error));
          } else if (state is ProfileLoaded) {
            final user = state.userModel;
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ProfileCubit>().getUserProfile();
              },
              color: ColorsManager.darkTeal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: ColorsManager.lighterGray,
                              backgroundImage:
                                  (user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(
                                      "${user.avatarUrl!}?t=${DateTime.now().millisecondsSinceEpoch}",
                                    )
                                  : null,
                              child:
                                  (user.avatarUrl == null ||
                                      user.avatarUrl!.isEmpty)
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: ColorsManager.gray,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        ("${user.fullName}"
                                    "${user.nickname}"
                                .isNotEmpty)
                            ? "${user.fullName} ${user.nickname}"
                            : "No Name",
                        style: TextStyles.font18BlackBold,
                      ),
                      SizedBox(height: 5),
                      Text(
                        (user.phoneNumber?.isNotEmpty ?? false)
                            ? user.phoneNumber!
                            : "No Phone",
                        style: TextStyles.font14GrayBlack,
                      ),
                      SizedBox(height: 20),
                      CustomGoScreen(
                        iconSvg: AppAssets.userEdit,
                        title: 'Edit Profile',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FillProfileScreen(
                                userModel: user,
                                firstName: user.fullName ?? '',
                                email: user.email,
                              ),
                            ),
                          ).then((_) {
                            if (context.mounted) {
                              context.read<ProfileCubit>().getUserProfile();
                            }
                          });
                        },
                      ),
                      CustomGoScreen(
                        iconSvg: AppAssets.favorite,
                        title: "Favorites",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesScreen(),
                            ),
                          );
                        },
                      ),
                      CustomGoScreen(
                        iconSvg: AppAssets.notification,
                        title: "Notifications",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                      ),
                      CustomGoScreen(
                        iconSvg: AppAssets.settings,
                        title: "Settings",
                      ),
                      CustomGoScreen(
                        iconSvg: AppAssets.help,
                        title: "Help and Support",
                      ),
                      CustomGoScreen(
                        iconSvg: AppAssets.terms,
                        title: "Terms and Conditions",
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => LogoutDialog(
                              onConfirm: () async {
                                await context.read<ProfileCubit>().logout();
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AppAssets.logout),
                            SizedBox(width: 10),
                            Text(
                              "Log Out",
                              style: TextStyles.font18BlackBold.copyWith(
                                color: ColorsManager.gray,
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
