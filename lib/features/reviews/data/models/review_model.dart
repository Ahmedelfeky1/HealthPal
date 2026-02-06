class ReviewModel {
  final int id;
  final double rating;
  final String comment;
  final String createdAt;
  final String userName;
  final String? userImage;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.userName,
    this.userImage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      comment: json['comment'] ?? '',
      createdAt: json['created_at'].toString().split('T')[0],
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),
      userName: json['profiles'] != null
          ? json['profiles']['full_name']
          : 'User',

      userImage: json['profiles'] != null
          ? json['profiles']['avatar_url']
          : null,
    );
  }
}
