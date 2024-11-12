import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

import '/core/models/models.dart';
import '/core/services/base_services.dart';
import '/core/services/gs_services.dart';

class AuthProvider with BaseService {
  void dispose() {}

  Future<GetLoginModel> signIn({required String userName, required String password}) async {
    return tryOrCatch<GetLoginModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.login',
        data: {'usr': userName, 'pwd': password},
      );

      final GetLoginModel user = GetLoginModel.fromMap(response.data);
      return user;
    });
  }

  Future<GetResponseModel> sendOtp({required String mobileNumber}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.send_otp',
        data: {'mobile_no': mobileNumber},
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetLoginModel> validateOtp({required String mobileNumber, required String otp}) async {
    return tryOrCatch<GetLoginModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.validate_otp',
        data: {'mobile_no': mobileNumber, 'otp': otp},
      );

      final GetLoginModel user = GetLoginModel.fromMap(response.data);
      return user;
    });
  }

  Future<GetResponseModel> forgotPassword({required String password}) async {
    return tryOrCatch<GetResponseModel>(() async {
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.general_api.forgot_password',
        data: {'password': password},
      );

      return GetResponseModel.fromResponse(response);
    });
  }

  Future<GetLoginModel> validateToken({required String idToken}) async {
    return tryOrCatch<GetLoginModel>(() async {
      log("idToken: $idToken");
      final response = await dio.post(
        '/api/method/qm_trading.mobile$apiVersion.user.validate_token',
        data: {'login': true, 'id_token': idToken},
      );

      final GetLoginModel user = GetLoginModel.fromMap(response.data);
      return user;
    });
  }

  Future<UserCredential> onGoogleSignIn() async {
    return tryOrCatch<UserCredential>(() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  Future<UserCredential> onFacebookSignIn() async {
    return tryOrCatch<UserCredential>(() async {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    });
  }

  Future<UserCredential> onXSignIn() async {
    return tryOrCatch<UserCredential>(() async {
      final TwitterLogin twitterLogin = TwitterLogin(
        apiKey: 'BMpkExKSkj1oZrD3k1JY2RRbh',
        apiSecretKey: 'xYJvYUZQd7bt2KuTNPM7pBgwWHUGQTi7OsUClatG1rlGcUp70G',
        redirectURI: 'qm-trading-app-48318://',
      );

      final AuthResult authResult = await twitterLogin.login();

      final OAuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
    });
  }

  Future<UserCredential> onAppleSignIn() async {
    /// Generates a cryptographically secure random nonce, to be included in a
    /// credential request.
    String generateNonce([int length = 32]) {
      const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = math.Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    return tryOrCatch<UserCredential>(() async {
      final String rawNonce = generateNonce();
      final String nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        nonce: nonce,
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final OAuthCredential oauthCredential = OAuthProvider("apple.com").credential(
        rawNonce: rawNonce,
        idToken: appleCredential.identityToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    });
  }

  Future<bool> logout() async {
    return tryOrCatch<bool>(() async {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      // Set default local language to english
      await GSServices.setLocale(GetLanguageModel.defaultLocale());
      await GSServices.setBiometricAuth(isEnabled: false);
      await Get.forceAppUpdate();
      await GSServices.clearLocalStorage();
      return true;
    });
  }
}
