import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qm_mlm_flutter/design/screens/init_controller.dart';

import '../../../utils/constants.dart';
import '/core/models/models.dart';
import '/core/repositories/auth_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  GlobalKey<FormState> mobileNoformKey = GlobalKey<FormState>();
  GlobalKey<FormState> newPasswordformKey = GlobalKey<FormState>();

  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  GetCountryCodeModel selectedCountryCode = Get.find<InitController>().defaultCountryCode;

  void onCountryCodeChanged(GetCountryCodeModel value) {
    selectedCountryCode = value;
    update();
  }

  Future<void> onMobileNumberSubmit() async {
    if (mobileNoformKey.currentState?.validate() ?? false) {
      final GetResponseModel? response = await _authRepository.sendOtp(
        mobileNumber: formatMobileNumber(selectedCountryCode.code, mobileNumberController.text),
      );
      if (response?.isSuccess == true) {
        Get.toNamed(
          Routes.FORGOT_PASSWORD_2,
          arguments: {
            "mobile_number": formatMobileNumber(
              selectedCountryCode.code,
              mobileNumberController.text,
            )
          },
        );
      }
    }
  }

  Future<void> changePassword() async {
    if (newPasswordformKey.currentState?.validate() ?? false) {
      Get.context?.loaderOverlay.show();

      final GetResponseModel? response = await _authRepository.forgotPassword(
        password: confirmPasswordController.text.trim(),
      );

      Get.context?.loaderOverlay.hide();

      if (response?.isSuccess == true) {
        await showSuccessDialog(successMessage: response?.message);
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}
