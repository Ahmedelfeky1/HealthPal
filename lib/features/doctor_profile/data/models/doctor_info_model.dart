
class DoctorInfoModel {
  final String specialty;
  final int price;
  final String about;
  final String workingHours;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;

  DoctorInfoModel({
    required this.specialty,
    required this.price,
    required this.about,
    required this.workingHours,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
  });

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      specialty: json['specialty'] ?? '',
      price: json['price'] != null ? json['price'] as int : 0,
      about: json['about'] ?? '',
      workingHours: json['working_hours'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : 0.0,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : 0.0,
      phone: json['phone'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'specialty': specialty,
      'price': price,
      'about': about,
      'working_hours': workingHours,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
    };
  }
}
