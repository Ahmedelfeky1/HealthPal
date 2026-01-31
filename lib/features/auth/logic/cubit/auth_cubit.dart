import 'package:bloc/bloc.dart';
import 'package:doctor_appointment/features/auth/data/models/signup_model.dart';
import 'package:doctor_appointment/features/auth/data/services/auth_service.dart';
import 'package:meta/meta.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> signup(SignupModel signupModel) async {
    emit(AuthLoading());
    try {
      await authService.signup(signupModel);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyCode({required String email, required String code}) async {
    emit(AuthLoading());
    try {
      final cleanEmail = email.trim();
      final cleanCode = code.trim();
      await authService.verifyCode(email: cleanEmail, code: cleanCode);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendResetCode({required String email}) async {
    emit(AuthLoading());
    try {
      final cleanEmail = email.trim();
      await authService.sendResetCode(cleanEmail);
      emit(AuthCodeSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updatePassword({required String newPassword}) async {
    emit(AuthLoading());

    try {
      await authService.updatePassword(newPassword: newPassword);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signin({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      await authService.signin(email: email, password: password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
