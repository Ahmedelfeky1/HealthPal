import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/core/helpers/location_helper.dart';
import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:doctor_appointment/features/doctors/data/services/doctors_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  Position? userPosition;
  final DoctorsServices doctorsServices;
  List<DoctorModel> allDoctors = [];
  DoctorCubit(this.doctorsServices) : super(HomeInitial());

  Future<void> getDoctors() async {
    emit(DoctorsLoading());
    try {
      await getUserLocation();
      final doctors = await doctorsServices.getDoctors();
      allDoctors = doctors;
      emit(DoctorsSuccess(doctors));
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  void filterDoctors(String speciality) {
    if (speciality == "All") {
      emit(DoctorsSuccess(allDoctors));
    } else {
      final filteredList = allDoctors.where((doctor) {
        return doctor.specialty.toLowerCase() == speciality.toLowerCase();
      }).toList();
      emit(DoctorsSuccess(filteredList));
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      emit(DoctorsSuccess(allDoctors));
    } else {
      final searchResult = allDoctors.where((doctor) {
        final nameMatch = doctor.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final specialtyMatch = doctor.specialty.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatch || specialtyMatch;
      }).toList();

      emit(DoctorsSuccess(searchResult));
    }
  }

  Future<void> getUserLocation() async {
    try {
      userPosition = await LocationHelper.getCurrentLocation();
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

}
