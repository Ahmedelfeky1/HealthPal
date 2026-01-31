import 'package:doctor_appointment/features/booking/data/model/appointment_model.dart';
import 'package:doctor_appointment/features/booking/data/model/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<void> createBooking(BookingModel bookingModel) async {
    final userId = supabaseClient.auth.currentUser!.id;
    final Map<String, dynamic> data = bookingModel.toJson();
    data["user_id"] = userId;
    data["status"] = "pending";
    await supabaseClient.from("appointments").insert(data);
  }
}

class MyAppointmentsService {
  final SupabaseClient supabaseClient = Supabase.instance.client;
  Future<List<AppointmentModel>> getMyAppointments() async {
    final response = await supabaseClient
        .from("appointments")
        .select("*,doctors(name, image_url, specialty,address)")
        .order("date", ascending: false);
    final List<AppointmentModel> appointments = (response as List)
        .map((e) => AppointmentModel.fromJson(e))
        .toList();
    return appointments;
  }
}
