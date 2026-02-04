import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/reviews/data/models/review_model.dart';
import 'package:doctor_appointment/features/reviews/data/repo/reviews_repo.dart';
import 'package:meta/meta.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo reviewsRepo;
  ReviewsCubit(this.reviewsRepo) : super(ReviewsInitial());
  Future<void> getReviews(int doctorId) async {
    emit(ReviewsLoading());
    try {
      final reviews = await reviewsRepo.getReviews(doctorId);
      emit(ReviewsSuccess(reviews));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> addReview(int doctorId, int rating, String comment) async {
    try {
      await reviewsRepo.addReview(doctorId, rating, comment);
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
