import 'package:flutter/material.dart';

class ReviewsDoctorScreen extends StatelessWidget {
  const ReviewsDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),

      body: Center(child: Text("Reviews Screen")),
    );
  }
}
