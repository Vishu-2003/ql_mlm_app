import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:flutter/foundation.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';

import '/core/models/models.dart';
import '/core/providers/auth_provider.dart';
import '/core/services/base_services.dart';
import '/utils/utils.dart';

class AuthRepository {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  void dispose() {
    _authProvider.dispose();
  }

  FutureOr<GetLoginModel?> signIn({required String userName, required String password}) async {
    try {
      return await _authProvider.signIn(userName: userName, password: password);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  FutureOr<GetResponseModel?> sendOtp({String? mobileNumber}) async {
    try {
      if (isNullEmptyOrFalse(mobileNumber)) throw AppException("Mobile number is required");
      return await _authProvider.sendOtp(mobileNumber: mobileNumber!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetLoginModel?> validateOtp({String? mobileNumber, String? otp}) async {
    try {
      if (isNullEmptyOrFalse(mobileNumber)) throw AppException("Mobile number is required");
      if (isNullEmptyOrFalse(otp)) throw AppException("OTP is required");
      return await _authProvider.validateOtp(mobileNumber: mobileNumber!, otp: otp!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetResponseModel?> forgotPassword({required String password}) async {
    try {
      if (isNullEmptyOrFalse(password)) throw AppException("Password is required");
      return await _authProvider.forgotPassword(password: password);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<GetLoginModel?> validateToken({required String? idToken}) async {
    try {
      if (isNullEmptyOrFalse(idToken)) throw AppException("Id token is required");
      return await _authProvider.validateToken(idToken: idToken!);
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserCredential?> onGoogleSignIn() async {
    try {
      return await _authProvider.onGoogleSignIn();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserCredential?> onFacebookSignIn() async {
    try {
      return await _authProvider.onFacebookSignIn();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserCredential?> onXSignIn() async {
    try {
      return await _authProvider.onXSignIn();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserCredential?> onAppleSignIn() async {
    try {
      return await _authProvider.onAppleSignIn();
    } on BadResponseException catch (e) {
      e.message?.errorSnackbar();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> logout() async {
    try {
      return await _authProvider.logout();
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
