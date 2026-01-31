part of 'favorites_cubit.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesSuccess extends FavoritesState {
  final List<int> favoriteIds;
  FavoritesSuccess(this.favoriteIds);
}

final class FavoritesError extends FavoritesState {
  final String error;
  FavoritesError(this.error);
}
