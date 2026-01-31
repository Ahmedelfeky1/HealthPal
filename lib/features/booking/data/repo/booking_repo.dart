import 'package:doctor_appointment/features/booking/data/model/booking_model.dart';
import 'package:doctor_appointment/features/booking/data/service/booking_service.dart';

class BookingRepo {
  final BookingService bookingService;
  BookingRepo({required this.bookingService});
  Future<void> bookAppointment(BookingModel bookingModel) async {
    try {
      await bookingService.createBooking(bookingModel);
    } catch (e) {
      throw e.toString();
    }
  }
}
