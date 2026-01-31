class AppointmentModel {
  final int id;
  final int doctorId;
  final String date;
  final String time;
  final String status;
  final String note;
  final String doctorName;
  final String doctorImage;
  final String speciality;
  final String address;
  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    required this.note,
    required this.doctorName,
    required this.doctorImage,
    required this.speciality,
    required this.address,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      doctorId: json['doctor_id'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      note: json['note'] ?? "",
      doctorName: json['doctors']['name'],
      doctorImage: json['doctors']['image_url'],
      speciality: json['doctors']['specialty'] ?? " ",
      address: json['doctors']['address'] ?? " ",
    );
  }
}
