import 'package:doctor_appointment/features/doctor_profile/data/models/doctor_info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorInfoServices {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> updateDoctorInfo(DoctorInfoModel doctorInfo) async {
    try {
      final String currentUserId = supabase.auth.currentUser!.id;

      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('id', currentUserId)
          .maybeSingle();
      String? doctorName = 'Dr.UnKnown';
      String? doctorImage;
      if (profileData != null) {
        doctorName =
            profileData['full_name'] ?? profileData['nickname'] ?? 'Dr.UnKnown';

        doctorImage = profileData['avatar_url'];
      }

      final Map<String, dynamic> dataToSend = {
        ...doctorInfo.toJson(),
        'user_id': currentUserId,
        'name': doctorName,
        'image_url': doctorImage,
      };
      await supabase.from('doctors').upsert(dataToSend, onConflict: 'user_id');
    } catch (e) {
      throw Exception('Failed to update doctor info: $e');
    }
  }

  Future<DoctorInfoModel?> getDoctorInfo() async {
    try {
      final currentUserId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('doctors')
          .select()
          .eq('user_id', currentUserId)
          .maybeSingle();
      if (data == null) {
        return null;
      }

      return DoctorInfoModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get doctor info: $e');
    }
  }

  Future<Map<String, dynamic>> getDoctorStats(int doctorId) async {
    try {
      final reviewsResponse = await supabase
          .from('reviews')
          .select('rating') // مش محتاجين باقي الداتا، عايزين الرقم بس
          .eq('doctor_id', doctorId);

      // 2. نحسب المتوسط (Average)
      double averageRating = 0.0;
      final reviewsList = reviewsResponse as List;

      if (reviewsList.isNotEmpty) {
        // نجمع كل التقييمات
        double totalRating = reviewsList.fold(
          0.0,
          (sum, item) => sum + (item['rating'] as num),
        );
        // نقسم المجموع على العدد
        averageRating = totalRating / reviewsList.length;
      }

      // نقرب الرقم لرقم عشري واحد (مثلاً 4.5 مش 4.53333)
      // (اختياري: ممكن تعملها في الـ UI بس هنا أريح)
      averageRating = double.parse(averageRating.toStringAsFixed(1));

      // 3. عدد الريفيوهات (هو هو طول الليستة اللي جبناها فوق)
      final reviewsCount = reviewsList.length;

      final patientsCount = await supabase
          .from('appointments')
          .count(CountOption.exact)
          .eq('doctor_id', doctorId);

      final doctorData = await supabase
          .from('doctors')
          .select('experience_years')
          .eq('id', doctorId)
          .single();
      return {
        'reviewsCount': reviewsCount,
        'patientsCount': patientsCount,
        'experience': doctorData['experience_years'] ?? '0',
        'rating': averageRating,
      };
    } catch (e) {
      print("❌ Error fetching stats: $e");
      return {
        'reviewsCount': 0,
        'patientsCount': 0,
        'experience': '0',
        'rating': 0.0,
      };
    }
  }
}
