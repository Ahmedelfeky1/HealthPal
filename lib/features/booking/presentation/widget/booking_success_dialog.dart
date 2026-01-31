import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/theming/colors.dart'; 

class BookingSuccessDialog extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;

  const BookingSuccessDialog({
    super.key,
    required this.doctorName,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r), 
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1), 
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green, size: 40.sp),
            ),
            SizedBox(height: 24.h),

            
            Text(
              "Congratulations!",
              style: TextStyles.font18BlackBold.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 16.h),

           
            Text(
              "Your appointment with Dr. $doctorName is confirmed for $date at $time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                height: 1.5, 
              ),
            ),
            SizedBox(height: 32.h),

            
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.darkBlue, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            
            GestureDetector(
              onTap: () {
                print("Edit clicked");
              },
              child: Text(
                "Edit your appointment",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
