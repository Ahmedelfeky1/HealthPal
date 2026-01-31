import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/features/booking/data/model/booking_model.dart';
import 'package:doctor_appointment/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:doctor_appointment/features/booking/presentation/widget/booking_calendar.dart';
import 'package:doctor_appointment/features/booking/presentation/widget/booking_success_dialog.dart';
import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctorModel;
  const BookingScreen({super.key, required this.doctorModel});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDay;
  int? selectedTimeIndex;
  final List<String> bookingTimes = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
  ];
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: ColorsManager.darkTeal),
            ),
          );
        } else if (state is BookingSuccess) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => BookingSuccessDialog(
              doctorName: widget.doctorModel.name,
              date:
                  "${selectedDay!.year}-${selectedDay!.month}-${selectedDay!.day}",
              time: bookingTimes[selectedTimeIndex!],
            ),
          );
        } else if (state is BookingError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsManager.errorRed,
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
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text("Book Appointment", style: TextStyles.font18BlackBold),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Date", style: TextStyles.font18BlackBold),
              SizedBox(height: 15.h),
              BookingCalendar(
                onDateSelected: (date) {
                  setState(() {
                    selectedDay = date;
                  });
                },
              ),

              SizedBox(height: 20),

              Text("Select Time", style: TextStyles.font18BlackBold),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: bookingTimes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTimeIndex == index
                              ? ColorsManager.darkTeal
                              : ColorsManager.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: selectedTimeIndex == index
                                ? Colors.transparent
                                : ColorsManager.gray50,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          bookingTimes[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: selectedTimeIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomButton(
                text: "Confirm",
                onPressed: () {
                  if (selectedDay == null || selectedTimeIndex == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select date and time"),
                      ),
                    );
                    return;
                  }
                  final formattedDate =
                      "${selectedDay!.year}-${selectedDay!.month}-${selectedDay!.day}";
                  final bookingModel = BookingModel(
                    doctorId: widget.doctorModel.id,
                    date: formattedDate,
                    time: bookingTimes[selectedTimeIndex!],
                    note: "New Booking",
                  );
                  context.read<BookingCubit>().creaateBooking(bookingModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
