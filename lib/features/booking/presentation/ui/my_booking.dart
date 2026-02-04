import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:doctor_appointment/core/widgets/custom_elvat_bt.dart';
import 'package:doctor_appointment/features/booking/data/repo/booking_repo.dart';
import 'package:doctor_appointment/features/booking/data/repo/my_appointments_repo.dart';
import 'package:doctor_appointment/features/booking/data/service/booking_service.dart';
import 'package:doctor_appointment/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:doctor_appointment/features/booking/logic/cubit/my_appointments_cubit.dart';
import 'package:doctor_appointment/features/booking/presentation/ui/booking_screen.dart';
import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_appointment/features/reviews/data/repo/reviews_repo.dart';
import 'package:doctor_appointment/features/reviews/data/services/reviews_service.dart';
import 'package:doctor_appointment/features/reviews/logic/cubit/reviews_cubit.dart';
import 'package:doctor_appointment/features/reviews/presentation/widget/add_review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBooking extends StatelessWidget {
  const MyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAppointmentsCubit(
        MyAppointmentsRepo(myAppointmentsService: MyAppointmentsService()),
      )..getAppointments(),
      child: MyBookingBody(),
    );
  }
}

class MyBookingBody extends StatefulWidget {
  const MyBookingBody({super.key});

  @override
  State<MyBookingBody> createState() => _MyBookingBodyState();
}

class _MyBookingBodyState extends State<MyBookingBody> {
  List<String> tapList = ['Upcoming', 'Completed', 'Cancelled'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.white,
      appBar: AppBar(
        backgroundColor: ColorsManager.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("My Booking", style: TextStyles.font18BlackBold),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(tapList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: selectedIndex == index
                            ? Border(
                                bottom: BorderSide(
                                  color: ColorsManager.darkTeal,
                                  width: 3.w,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        tapList[index],
                        style: TextStyles.font18BlackBold.copyWith(
                          fontSize: 15.sp,
                          color: selectedIndex == index
                              ? ColorsManager.darkTeal
                              : ColorsManager.lighterGray,
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Divider(color: ColorsManager.lighterGray, thickness: 1),
              SizedBox(height: 20.h),
              Expanded(
                child: BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
                  builder: (context, state) {
                    if (state is MyAppointmentsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.darkTeal,
                        ),
                      );
                    } else if (state is MyAppointmentsError) {
                      return Center(child: Text(state.error));
                    } else if (state is MyAppointmentsSuccess) {
                      final filterdList = state.appointments.where((
                        appointemt,
                      ) {
                        final status = appointemt.status.toLowerCase();
                        if (selectedIndex == 0) {
                          return status == 'pending' || status == 'confirmed';
                        } else if (selectedIndex == 1) {
                          return status == 'completed';
                        } else {
                          return status == 'cancelled';
                        }
                      }).toList();
                      return RefreshIndicator(
                        color: ColorsManager.darkTeal,
                        backgroundColor: ColorsManager.white,
                        onRefresh: () async {
                          await context
                              .read<MyAppointmentsCubit>()
                              .getAppointments();
                        },

                        child: filterdList.isEmpty
                            ? ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 50.sp,
                                          color: ColorsManager.lighterGray,
                                        ),
                                        Text(
                                          "No appointments found",
                                          style: TextStyles.font18BlackBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: filterdList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final appointment = filterdList[index];
                                  return Container(
                                    padding: EdgeInsets.all(12.h),
                                    margin: EdgeInsets.only(bottom: 16.h),
                                    decoration: BoxDecoration(
                                      color: ColorsManager.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${appointment.date} | ${appointment.time}",
                                          style: TextStyles.font18BlackBold
                                              .copyWith(fontSize: 15.sp),
                                        ),
                                        SizedBox(height: 8.h),
                                        Divider(
                                          color: ColorsManager.lighterGray,
                                          height: 1,
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: Image.network(
                                                appointment.doctorImage,
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      width: 80.w,
                                                      height: 80.h,
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    appointment.doctorName,
                                                    style: TextStyles
                                                        .font18BlackBold
                                                        .copyWith(
                                                          fontSize: 16.sp,
                                                        ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    appointment.speciality,
                                                    style: TextStyles
                                                        .font18BlackBold
                                                        .copyWith(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: ColorsManager
                                                            .darkTeal,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Expanded(
                                                        child: Text(
                                                          appointment.address,
                                                          style: TextStyles
                                                              .font18BlackBold
                                                              .copyWith(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.h),
                                        Divider(
                                          color: ColorsManager.lighterGray,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: 4.h),
                                        if (selectedIndex == 0)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  text: "Cancel",
                                                  textColor:
                                                      ColorsManager.darkTeal,
                                                  backgroundColor:
                                                      ColorsManager.lighterGray,
                                                  borderRadius: 30.r,
                                                  onPressed: () {
                                                    final cubit = context
                                                        .read<
                                                          MyAppointmentsCubit
                                                        >();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        backgroundColor:
                                                            ColorsManager.white,
                                                        title: Text(
                                                          "Cancel Appointment",
                                                          style: TextStyles
                                                              .font18BlackBold,
                                                        ),
                                                        content: Text(
                                                          "Are you sure you want to cancel this appointment?",
                                                          style: TextStyles
                                                              .font16WhiteSemiBold,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              cubit
                                                                  .cancelAppointment(
                                                                    appointment
                                                                        .id,
                                                                  );
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              "No",
                                                              style: TextStyles
                                                                  .font18BlackBold
                                                                  .copyWith(
                                                                    color:
                                                                        ColorsManager
                                                                            .gray,
                                                                  ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              cubit
                                                                  .cancelAppointment(
                                                                    appointment
                                                                        .id,
                                                                  );
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyles
                                                                  .font18BlackBold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: CustomButton(
                                                  text: "Reschedule",
                                                  backgroundColor:
                                                      ColorsManager.darkTeal,
                                                  borderRadius: 30.r,
                                                  onPressed: () async {
                                                    final cubit = context
                                                        .read<
                                                          MyAppointmentsCubit
                                                        >();
                                                    final DateTime?
                                                    pickedDate = await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2030),
                                                      builder: (context, child) {
                                                        return Theme(
                                                          data: Theme.of(context).copyWith(
                                                            primaryColor:
                                                                ColorsManager
                                                                    .darkTeal,
                                                            colorScheme:
                                                                const ColorScheme.light(
                                                                  primary:
                                                                      ColorsManager
                                                                          .darkTeal,
                                                                ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                    );
                                                    if (pickedDate != null &&
                                                        context.mounted) {
                                                      final TimeOfDay?
                                                      pickedTime =
                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                          );
                                                      if (pickedTime != null &&
                                                          context.mounted) {
                                                        final String newDate =
                                                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                                        final String newTime =
                                                            pickedTime.format(
                                                              context,
                                                            );
                                                        cubit
                                                            .rescheduleAppointment(
                                                              appointment.id,
                                                              newDate,
                                                              newTime,
                                                            );
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        else if (selectedIndex == 1)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  text: "Re-Book",
                                                  textColor:
                                                      ColorsManager.darkTeal,
                                                  backgroundColor:
                                                      ColorsManager.lighterGray,
                                                  borderRadius: 30.r,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => BlocProvider(
                                                          create: (context) =>
                                                              BookingCubit(
                                                                BookingRepo(
                                                                  bookingService:
                                                                      BookingService(),
                                                                ),
                                                              ),
                                                          child: BookingScreen(
                                                            doctorModel: DoctorModel(
                                                              id: appointment
                                                                  .doctorId,
                                                              name: appointment
                                                                  .doctorName,
                                                              specialty:
                                                                  appointment
                                                                      .speciality,
                                                              imageUrl: appointment
                                                                  .doctorImage,
                                                              address:
                                                                  appointment
                                                                      .address,
                                                              rating: 0,
                                                              reviewsCount: 0,
                                                              patients: '0',
                                                              experience: '0',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: CustomButton(
                                                  text: "Add Review",
                                                  backgroundColor:
                                                      ColorsManager.darkTeal,
                                                  borderRadius: 30.r,
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          ColorsManager.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    20.r,
                                                                  ),
                                                            ),
                                                      ),
                                                      builder: (context) => BlocProvider(
                                                        create: (context) =>
                                                            ReviewsCubit(
                                                              ReviewsRepo(
                                                                reviewsService:
                                                                    ReviewsService(),
                                                              ),
                                                            ),
                                                        child:
                                                            AddReviewBottomSheet(
                                                              doctorId:
                                                                  appointment
                                                                      .doctorId,
                                                              appointmentId:
                                                                  appointment
                                                                      .id,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  text: "Re-Book",
                                                  textColor:
                                                      ColorsManager.darkTeal,
                                                  backgroundColor:
                                                      ColorsManager.lighterGray,
                                                  borderRadius: 30.r,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => BlocProvider(
                                                          create: (context) =>
                                                              BookingCubit(
                                                                BookingRepo(
                                                                  bookingService:
                                                                      BookingService(),
                                                                ),
                                                              ),
                                                          child: BookingScreen(
                                                            doctorModel: DoctorModel(
                                                              id: appointment
                                                                  .doctorId,
                                                              name: appointment
                                                                  .doctorName,
                                                              specialty:
                                                                  appointment
                                                                      .speciality,
                                                              imageUrl: appointment
                                                                  .doctorImage,
                                                              address:
                                                                  appointment
                                                                      .address,
                                                              rating: 0,
                                                              reviewsCount: 0,
                                                              patients: '0',
                                                              experience: '0',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
