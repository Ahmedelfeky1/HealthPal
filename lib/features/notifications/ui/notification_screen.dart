import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
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
      
    );
  }
}
