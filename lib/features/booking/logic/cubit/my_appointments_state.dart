part of 'my_appointments_cubit.dart';

@immutable
sealed class MyAppointmentsState {}

final class MyAppointmentsInitial extends MyAppointmentsState {}

final class MyAppointmentsLoading extends MyAppointmentsState {}

final class MyAppointmentsSuccess extends MyAppointmentsState {
  final List<AppointmentModel> appointments;
  MyAppointmentsSuccess(this.appointments);
}

final class MyAppointmentsError extends MyAppointmentsState {
  final String error;
  MyAppointmentsError({required this.error});
}
