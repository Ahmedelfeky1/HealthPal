import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/fovorites/data/services/favorites_service.dart';
import 'package:meta/meta.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService favoritesService;
  FavoritesCubit(this.favoritesService) : super(FavoritesInitial());

  List<int> favoriteIds = [];

  Future<void> getFavorites() async {
    emit(FavoritesLoading());
    try {
      favoriteIds = await favoritesService.getFavoriteDoctorId();
      emit(FavoritesSuccess(favoriteIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(int doctorId) async {
    try {
      if (favoriteIds.contains(doctorId)) {
        favoriteIds.remove(doctorId);
        await favoritesService.removeFromFavorites(doctorId);
      } else {
        favoriteIds.add(doctorId);
        await favoritesService.addToFavorites(doctorId);
      }

      emit(FavoritesSuccess(List.from(favoriteIds)));
    } catch (e) {
      emit(FavoritesError("Failed to update favorites"));
    }
  }
}
