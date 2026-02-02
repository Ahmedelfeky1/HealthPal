import 'dart:io';
import 'package:doctor_appointment/features/auth/data/models/signup_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        return supabase.auth.signInWithIdToken(
          provider: OAuthProvider.facebook,
          idToken: accessToken.tokenString,
          accessToken: accessToken.tokenString,
        );
      } else if (result.status == LoginStatus.cancelled) {
        throw "Facebook Sign-In canceled by user.";
      } else {
        throw 'Facebook Sign-In failed: ${result.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signInWithGoogle() async {
    const webClientId =
        '622340714786-pi55ebmk414smep1el5ot1t0nbitkeka.apps.googleusercontent.com';
    const iosClientId =
        '622340714786-udildof1omisc1retjb08nroncf60pe5.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS ? iosClientId : null,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw 'Google Sign-In canceled';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

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

  Future<bool> isUserCompletedProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    try {
      final data = await supabase
          .from("profiles")
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) return false;
      if (data['role'] == null || data['role'].toString().isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
