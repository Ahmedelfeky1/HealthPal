class UserProfileModel {
  final String? id;
  final String? fullName;
  final String nickname;
  final String? phoneNumber;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String role;
  final String? avatarUrl;

  UserProfileModel({
    this.id,
    required this.fullName,
    required this.nickname,
    required this.email,
    this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.role,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "nickname": nickname,
      "email": email,
      "phone_number": phoneNumber,
      "date_of_birth": dateOfBirth,
      "gender": gender,
      "role": role,
      "avatar_url": avatarUrl,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json["id"],
      fullName: json["full_name"],
      nickname: json["nickname"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      dateOfBirth: json["date_of_birth"],
      gender: json["gender"],
      role: json["role"],
      avatarUrl: json["avatar_url"],
    );
  }
}
