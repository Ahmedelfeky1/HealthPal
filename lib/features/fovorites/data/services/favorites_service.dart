import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesService {
  final supabase = Supabase.instance.client;
  Future<void> addToFavorites(int doctorId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    await supabase.from("favorites").insert({
      "user_id": user.id,
      "doctor_id": doctorId,
    });
  }

  Future<void> removeFromFavorites(int doctorId) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from("favorites").delete().match({
      "user_id": user.id,
      "doctor_id": doctorId,
    });
  }

  Future<List<int>> getFavoriteDoctorId() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from("favorites")
        .select("doctor_id")
        .eq("user_id", user.id);

    final List<int> favoriteIds = (response as List)
        .map((item) => item['doctor_id'] as int)
        .toList();

    return favoriteIds;
  }
}
