part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {}

final class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error);
}

final class ProfileLoaded extends ProfileState {
  final UserProfileModel userModel;
  ProfileLoaded(this.userModel);
}
final class ProfileLoggedOut extends ProfileState {}
