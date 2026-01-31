import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/booking/data/model/booking_model.dart';
import 'package:doctor_appointment/features/booking/data/repo/booking_repo.dart';
import 'package:meta/meta.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo bookingRepo;
  BookingCubit(this.bookingRepo) : super(BookingInitial());

  Future<void> creaateBooking(BookingModel bookingModel) async {
    emit(BookingLoading());

    try {
      await bookingRepo.bookAppointment(bookingModel);
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
