import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/core/models/models.dart';
import '/core/repositories/auth_repository.dart';
import '/core/routes/app_pages.dart';
import '/core/services/gs_services.dart';

class OtpController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    mobileNumber = Get.arguments['mobile_number'];
  }

  String? mobileNumber;
  FocusNode otpFocusNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> otpErrorController = StreamController<ErrorAnimationType>();

  Future<void> verifyOtp(String otp) async {
    Get.context?.loaderOverlay.show();
    final GetLoginModel? user =
        await authRepository.validateOtp(otp: otp, mobileNumber: mobileNumber);
    Get.context?.loaderOverlay.hide();
    if (user != null) {
      if (Get.previousRoute == Routes.FORGOT_PASSWORD_1) {
        Get.offNamedUntil(
          Routes.FORGOT_PASSWORD_3,
          (route) => route.settings.name == Routes.LOGIN,
          arguments: mobileNumber,
        );
      } else if (Get.previousRoute == Routes.LOGIN) {
        await GSServices.setUser(user: user);
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        debugPrint('Unknown route: ${Get.previousRoute}');
      }
    } else {
      otpErrorController.add(ErrorAnimationType.shake);
    }
  }
}
