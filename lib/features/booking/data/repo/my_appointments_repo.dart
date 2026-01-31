import 'package:doctor_appointment/features/booking/data/model/appointment_model.dart';
import 'package:doctor_appointment/features/booking/data/service/booking_service.dart';

class MyAppointmentsRepo {
  final MyAppointmentsService myAppointmentsService;
  MyAppointmentsRepo({required this.myAppointmentsService});

  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      return await myAppointmentsService.getMyAppointments();
    } catch (e) {
      throw e.toString();
    }
  }
}
