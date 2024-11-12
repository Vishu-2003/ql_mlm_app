import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

import '/core/models/models.dart';
import '/core/repositories/auth_repository.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/core/services/biometric_service.dart';
import '/core/services/gs_services.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  String appVersion = '';

  bool isLoading = false;
  BiometricType? biometricType;
  GetProfileModel? profileDetails;
  RxBool isBiometricAvailable = false.obs;
  ({Color? fontColor, Color? badgeColor})? badgeTheme;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading = true;
    update();

    appVersion = await getAppVersion();

    profileDetails = await _homeRepository.getUserProfile();
    badgeTheme = await _homeRepository.getBadgeDetails(
      badge: profileDetails?.currentBadge ?? "",
    );

    isBiometricAvailable.value = await BiometricService.checkBiometrics();
    biometricType = await BiometricService.getStrongBiometricType();

    isLoading = false;
    update();
  }

  Future<bool> toogleBiometric(bool value) async {
    if (value == true) {
      final bool authenticated = await BiometricService.authenticate();
      if (authenticated) {
        await GSServices.setBiometricAuth(isEnabled: true);
        update();
        return true;
      }
    } else {
      await GSServices.setBiometricAuth(isEnabled: false);
      update();
      return false;
    }
    return false;
  }

  Future<void> closeAccount() async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController reasonController = TextEditingController();
    await showConfirmationDialog(
      dialogImage: AppImages.caution,
      onPositiveButtonPressed: () async {
        if (formKey.currentState?.validate() == false) return;

        Get.context?.loaderOverlay.show();
        final GetResponseModel? response = await _homeRepository.closeAccount(
          reason: reasonController.text,
        );
        Get.context?.loaderOverlay.hide();

        if (response?.isSuccess == true) {
          Get.back();
          await showSuccessDialog(successMessage: response?.message);
          final bool loggedOut = await _authRepository.logout();
          if (loggedOut) Get.offAllNamed(Routes.LOGIN);
        }
      },
      onNegativeButtonPressed: Get.back,
      positiveButtonTitle: "Yes, Close",
      title: TranslationController.td.closeAccount,
      substitle: TranslationController.td.areYouSureYouWantToCloseYourAccount,
      bottomChild: Form(
        key: formKey,
        child: CTextField(
          minLines: 3,
          maxLines: 3,
          labelText: "Reason",
          controller: reasonController,
          validator: AppValidator.emptyNullValidator,
        ).paddingOnly(top: 12),
      ),
    );
  }
}
