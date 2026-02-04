part of 'reviews_cubit.dart';

@immutable
sealed class ReviewsState {}

final class ReviewsInitial extends ReviewsState {}
final class ReviewsLoading extends ReviewsState {}
final class ReviewsSuccess extends ReviewsState {
  final List<ReviewModel> reviews;
  ReviewsSuccess(this.reviews);
}
final class ReviewsError extends ReviewsState {
  final String erorr;
  ReviewsError(this.erorr);
}


