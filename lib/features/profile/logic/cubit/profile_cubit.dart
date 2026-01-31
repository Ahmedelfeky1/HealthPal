import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/profile/data/models/user_profile_model.dart';
import 'package:doctor_appointment/features/profile/data/services/profile_service.dart';
import 'package:meta/meta.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService profileService;
  ProfileCubit(this.profileService) : super(ProfileInitial());

  Future<void> getUserProfile() async {
    emit(ProfileLoading());
    try {
      final userProfile = await profileService.fetchUserProfile();
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileError("Failed to load user profile: ${e.toString()}"));
    }
  }

  Future<void> saveUserProfile({
    required String fullName,
    required String nickname,
    required String email,
    String? phoneNumber,
    required String dateOfBirth,
    required String gender,
    required String role,
    String? avatarUrl,
  }) async {
    emit(ProfileLoading());
    try {
      final userProfile = UserProfileModel(
        fullName: fullName,
        nickname: nickname,
        email: email,
        dateOfBirth: dateOfBirth,
        gender: gender,
        role: role,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      await profileService.completeProfile(userProfile);
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError("Failed to save user profile: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    try {
      await profileService.logout();
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError("Failed to logout: ${e.toString()}"));
    }
  }
}
