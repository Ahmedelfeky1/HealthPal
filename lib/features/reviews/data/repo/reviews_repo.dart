import 'package:doctor_appointment/features/reviews/data/models/review_model.dart';
import 'package:doctor_appointment/features/reviews/data/services/reviews_service.dart';

class ReviewsRepo {
  final ReviewsService reviewsService;

  ReviewsRepo({required this.reviewsService});

  Future<List<ReviewModel>> getReviews(int doctorId) async {
    try {
      return await reviewsService.getDoctorReviews(doctorId);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addReview(int doctorId, int rating, String comment) async {
    try {
      await reviewsService.addReview(doctorId, rating, comment);
    } catch (e) {
      throw e.toString();
    }
  }
}
