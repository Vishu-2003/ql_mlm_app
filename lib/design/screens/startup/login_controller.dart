import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/auth_repository.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/core/services/gs_services.dart';
import '/design/screens/init_controller.dart';
import '/design/screens/startup/verify_tac_view.dart';
import '/utils/utils.dart';

class LoginController extends GetxController {
  LoginType selectedLoginType = LoginType.username;
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetCountryCodeModel selectedCountryCode = Get.find<InitController>().defaultCountryCode;

  Rx<({GetLanguageModel data, String item})> selectedLanguage = (
    item: GetLanguageModel.defaultLocale().languageName,
    data: GetLanguageModel.defaultLocale()
  ).obs;

  RxBool obscurePassword = true.obs;
  final List<GetLanguageModel> languages = [];

  String appVersion = "";

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    languages.assignAll(await _homeRepository.getLanguages());
    appVersion = await getAppVersion();
    update();
  }

  void onLoginTypeChanged(LoginType? value) {
    if (value != null) {
      selectedLoginType = value;
      update();
    }
  }

  void onCountryCodeChanged(GetCountryCodeModel value) {
    selectedCountryCode = value;
    update();
  }

  Future<void> _redirectOnLogin(GetLoginModel? user) async {
    if (user != null) {
      if (user.tacVerified == false) {
        bool? isVerified = await showAdaptiveDialog<bool>(
          context: Get.context!,
          barrierDismissible: false,
          barrierColor: getDialogBarrierColor,
          builder: (context) {
            return TACVerificationView(email: user.user);
          },
        );

        if (isNullEmptyOrFalse(isVerified)) {
          return;
        }
        if (isVerified == true) {
          user.tacVerified = true;
        }
      }

      if (user.twoFactorAuthentication == true) {
        final GetResponseModel? response =
            await _authRepository.sendOtp(mobileNumber: user.mobileNo);
        if (response?.isSuccess == true) {
          Get.toNamed(Routes.OTP(mobileNumber: user.mobileNo!), arguments: user);
          return;
        }
      } else {
        await GSServices.setUser(user: user);
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } else {
      debugPrint("User is null");
    }
  }

  Future<void> signIn() async {
    if (formKey.currentState?.validate() ?? false) {
      Get.context?.loaderOverlay.show();
      final GetLoginModel? user = await _authRepository.signIn(
        password: passwordController.text,
        userName: selectedLoginType == LoginType.mobile
            ? formatMobileNumber(selectedCountryCode.code, mobileController.text)
            : userNameController.text,
      );
      Get.context?.loaderOverlay.hide();
      await _redirectOnLogin(user);
    }
  }

  Future<void> changeLanguage(({GetLanguageModel data, String item}) selectedLanguage) async {
    await GSServices.setLocale(selectedLanguage.data);
    await Get.forceAppUpdate();
    this.selectedLanguage.value = selectedLanguage;
  }

  Future<void> onGoogleSignIn() async {
    Get.context?.loaderOverlay.show();
    final UserCredential? credential = await _authRepository.onGoogleSignIn();
    final GetLoginModel? user =
        await _authRepository.validateToken(idToken: await credential?.user?.getIdToken());
    await _redirectOnLogin(user);
    Get.context?.loaderOverlay.hide();
  }

  Future<void> onFacebookSignIn() async {
    Get.context?.loaderOverlay.show();
    final UserCredential? credential = await _authRepository.onFacebookSignIn();
    final GetLoginModel? user =
        await _authRepository.validateToken(idToken: await credential?.user?.getIdToken());
    await _redirectOnLogin(user);
    Get.context?.loaderOverlay.hide();
  }

  Future<void> onXSignIn() async {
    Get.context?.loaderOverlay.show();
    final UserCredential? credential = await _authRepository.onXSignIn();
    final GetLoginModel? user =
        await _authRepository.validateToken(idToken: await credential?.user?.getIdToken());
    await _redirectOnLogin(user);
    Get.context?.loaderOverlay.hide();
  }

  Future<void> onAppleSignIn() async {
    Get.context?.loaderOverlay.show();
    final UserCredential? credential = await _authRepository.onAppleSignIn();
    final GetLoginModel? user =
        await _authRepository.validateToken(idToken: await credential?.user?.getIdToken());
    await _redirectOnLogin(user);
    Get.context?.loaderOverlay.hide();
  }
}
