import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '/utils/utils.dart';

class BiometricService {
  BiometricService._();

  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      log(e.toString());
    }
    return false;
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      log(e.toString());
    }
    return [];
  }

  static Future<BiometricType?> getStrongBiometricType() async {
    final List<BiometricType> availableBiometrics = await getAvailableBiometrics();
    debugPrint("availableBiometrics: $availableBiometrics");
    if (availableBiometrics.contains(BiometricType.face)) {
      return BiometricType.face;
    } else if (availableBiometrics.contains(BiometricType.face) ||
        availableBiometrics.contains(BiometricType.strong)) {
      return BiometricType.fingerprint;
    }
    return null;
  }

  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate is required to access the app',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException catch (e) {
      log(e.toString());
      e.message?.errorSnackbar();
    }
    return false;
  }
}
