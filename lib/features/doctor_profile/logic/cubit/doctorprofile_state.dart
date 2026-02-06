part of 'doctorprofile_cubit.dart';

@immutable
sealed class DoctorprofileState {}

final class DoctorprofileInitial extends DoctorprofileState {}

final class DoctorprofileLoading extends DoctorprofileState {}

final class DoctorprofileUpdating extends DoctorprofileState {}
final class DoctorprofileSuccess extends DoctorprofileState {}

final class DoctorprofileError extends DoctorprofileState {
  final String error;
  DoctorprofileError(this.error);
}

final class DoctorprofileLoaded extends DoctorprofileState {
  final DoctorInfoModel doctorData;
  DoctorprofileLoaded(this.doctorData);
}
