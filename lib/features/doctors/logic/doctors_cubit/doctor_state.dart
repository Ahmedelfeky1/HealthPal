part of 'doctor_cubit.dart';

@immutable sealed class DoctorState {}

final class HomeInitial extends DoctorState {}

final class DoctorsLoading extends DoctorState {}

final class DoctorsSuccess extends DoctorState {
  final List<DoctorModel> doctors;
  DoctorsSuccess(this.doctors);
}

final class DoctorsError extends DoctorState {
  final String error;
  DoctorsError(this.error);
}
