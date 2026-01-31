class DoctorModel {
  final int id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String address;
  final String patients;
  final String experience;
  final int? price;
  final String? about;
  final String? workingHours;
  final double? latitude;
  final double? longitude;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.address,
    this.price,
    this.about,
    this.workingHours,
    this.latitude,
    this.longitude,
    required this.patients,
    required this.experience,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      specialty: json['specialty'] ?? 'General',
      imageUrl: json['image_url'] ?? 'No image',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
      address: json['address'] ?? 'No Address',
      price: json['price'],
      about: json['about'],
      workingHours: json['working_hours'],
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      patients: json['patients'] ?? '0+',
      experience: json['experience_years']??'0+',
    );
  }
}
