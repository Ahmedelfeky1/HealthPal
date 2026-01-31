import 'package:doctor_appointment/core/theming/colors.dart';
import 'package:doctor_appointment/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const BookingCalendar({super.key, required this.onDateSelected});

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.gray50.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 12, 31),
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: (selected, focusedDay) {
          setState(() {
            selectedDay = selected;
            focusedDay = focusedDay;
          });
          widget.onDateSelected(selected);
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: ColorsManager.darkTeal,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: ColorsManager.white),
          todayDecoration: BoxDecoration(
            color: ColorsManager.darkTeal.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyles.font18BlackBold,
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
        ),
      ),
    );
  }
}
