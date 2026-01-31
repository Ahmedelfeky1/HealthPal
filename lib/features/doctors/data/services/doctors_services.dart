import 'package:doctor_appointment/features/doctors/data/models/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorsServices {
  final SupabaseClient supabaseClient;

  DoctorsServices(this.supabaseClient);

  Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await supabaseClient.from('doctors').select();
      final List<DoctorModel> doctors = (response as List)
          .map((e) => DoctorModel.fromJson(e))
          .toList();
      return doctors;
    } catch (e) {
      throw Exception('Failed doctors: $e');
    }
  }
}
