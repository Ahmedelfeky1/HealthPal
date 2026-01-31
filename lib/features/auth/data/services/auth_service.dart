import 'package:doctor_appointment/features/auth/data/models/signup_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> signup(SignupModel signupModel) async {
    await supabase.auth.signUp(
      email: signupModel.email,
      password: signupModel.password,
      data: signupModel.toBody(),
    );
  }

  Future<void> signin({required String email, required String password}) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Future<void> verifyCode({required String email, required String code}) async {
    await supabase.auth.verifyOTP(
      type: OtpType.recovery,
      email: email,
      token: code,
    );
  }

  Future<void> sendResetCode(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword({required String newPassword}) async {
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }
}
