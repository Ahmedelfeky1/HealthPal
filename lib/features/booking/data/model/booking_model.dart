class BookingModel {
  final int doctorId;
  final String date;
  final String time;
  final String note;

  BookingModel({
    required this.doctorId,
    required this.date,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {'doctor_id': doctorId, 'date': date, 'time': time, 'note': note};
  }
}
