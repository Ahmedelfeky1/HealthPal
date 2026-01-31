import 'dart:io';
import 'package:doctor_appointment/features/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<void> completeProfile(UserProfileModel userProfile) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final profileData = userProfile.toJson();

    profileData["id"] = user.id;
    profileData["updated_at"] = DateTime.now().toIso8601String();

    await supabase.from("profiles").upsert(profileData);
  }

  Future<UserProfileModel> fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final data = await supabase
        .from("profiles")
        .select()
        .eq("id", user.id)
        .single();

    return UserProfileModel.fromJson(data);
  }

  Future<String> uploadImage(File imageFile) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User Not Logged in");

    final String path = "${user.id}/profile.jpg";
    await supabase.storage
        .from('avatars')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

    final String imageUrl = supabase.storage.from('avatars').getPublicUrl(path);

    return "$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
