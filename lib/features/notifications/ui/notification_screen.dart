import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/features/notifications/data/model/notifications_model.dart';
import 'package:doctor_appointment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsManager.white,
        title: Text("Notifications", style: TextStyles.font18BlackBold),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsManager.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('notifications')
            .stream(primaryKey: ['id'])
            .eq('user_id', supabase.auth.currentUser!.id)
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorsManager.darkTeal),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80.sp,
                    color: ColorsManager.darkTeal,
                  ),
                  SizedBox(height: 20.h),
                  Text("No Notifications", style: TextStyles.font18BlackBold),
                ],
              ),
            );
          }
          final notifications = snapshot.data!
              .map((e) => NotificationsModel.fromJson(e))
              .toList();
          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? ColorsManager.gray
                      : ColorsManager.darkTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: notification.isRead
                        ? ColorsManager.gray.withOpacity(0.1)
                        : ColorsManager.darkTeal.withOpacity(0.1),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.darkTeal.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notification.type == 'appointment'
                            ? Icons.calendar_today
                            : Icons.notifications,
                        color: ColorsManager.darkTeal,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notification.title,
                                style: TextStyles.font14GrayBlack,
                              ),
                              Text(
                                DateFormat(
                                  'MMM d, h:mm a',
                                ).format(notification.createdAt),
                                style: TextStyles.font12WhiteRegular.copyWith(
                                  color: ColorsManager.gray,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            notification.body,
                            style: TextStyles.font14GrayBlack,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: notifications.length,
          );
        },
      ),
    );
  }
}
