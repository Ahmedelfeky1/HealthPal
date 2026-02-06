import 'package:doctor_appointment/features/reviews/data/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewsService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<List<ReviewModel>> getDoctorReviews(int doctorId) async {
    final response = await supabaseClient
        .from('reviews')
        .select('*, profiles(full_name, avatar_url)')
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);
    final List<ReviewModel> reviews = (response as List)
        .map((e) => ReviewModel.fromJson(e))
        .toList();
    return reviews;
  }

  Future<void> addReview(int doctorId, int rating, String comment) async {
    await supabaseClient.from('reviews').insert({
      'user_id': supabaseClient.auth.currentUser!.id,
      'doctor_id': doctorId,
      'rating': rating,
      'comment': comment,
    });
  }
}
