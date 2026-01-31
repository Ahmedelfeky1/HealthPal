import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/booking/data/model/appointment_model.dart';
import 'package:doctor_appointment/features/booking/data/repo/my_appointments_repo.dart';
import 'package:meta/meta.dart';

part 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final MyAppointmentsRepo myAppointmentsRepo;
  MyAppointmentsCubit(this.myAppointmentsRepo) : super(MyAppointmentsInitial());

  Future<void> getAppointments() async {
    emit(MyAppointmentsLoading());
    try {
      final appointemts = await myAppointmentsRepo.getMyAppointments();
      emit(MyAppointmentsSuccess(appointemts));
    } catch (e) {
      emit(MyAppointmentsError(error: e.toString()));
    }
  }
}
