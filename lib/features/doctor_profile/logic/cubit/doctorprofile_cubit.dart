import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/doctor_profile/data/models/doctor_info_model.dart';
import 'package:doctor_appointment/features/doctor_profile/data/services/doctor_info_services.dart';
import 'package:meta/meta.dart';

part 'doctorprofile_state.dart';

class DoctorprofileCubit extends Cubit<DoctorprofileState> {
  final DoctorInfoServices doctorInfoServices;
  DoctorprofileCubit(this.doctorInfoServices) : super(DoctorprofileInitial());

  Future<void> saveDoctorProfile(DoctorInfoModel doctorInfo) async {
    emit(DoctorprofileUpdating());
    try {
      await doctorInfoServices.updateDoctorInfo(doctorInfo);
      emit(DoctorprofileSuccess());
    } catch (e) {
      emit(DoctorprofileError(e.toString()));
    }
  }

  Future<void> getDoctorProfile() async {
    emit(DoctorprofileLoading());
    try {
      final doctorData = await doctorInfoServices.getDoctorInfo();
      if (doctorData != null) {
        emit(DoctorprofileLoaded(doctorData));
      } else {
        emit(DoctorprofileInitial());
      }
    } catch (e) {
      emit(DoctorprofileError(e.toString()));
    }
  }
}
