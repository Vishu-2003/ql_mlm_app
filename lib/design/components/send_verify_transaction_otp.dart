import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qm_mlm_flutter/core/repositories/home_repository.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

import '../../core/models/models.dart';
import 'otp_verification_view.dart';

Future<bool?> sendVerifyTransactionOtp({required OTPTransactionType transactionType}) async {
  final HomeRepository homeRepository = Get.find<HomeRepository>();

  Get.context?.loaderOverlay.show();
  await homeRepository.sendTransactionOtp(type: transactionType);
  Get.context?.loaderOverlay.hide();

  return await showAdaptiveDialog<bool>(
    context: Get.context!,
    barrierDismissible: false,
    barrierColor: getDialogBarrierColor,
    builder: (context) {
      StreamController<ErrorAnimationType>? errorAnimationController =
          StreamController<ErrorAnimationType>();

      return OTPVerificationView(
        onCompleted: (String code) async {
          GetResponseModel? verificationResponse =
              await homeRepository.verifyTransactionOtp(code: code, type: transactionType);

          if (verificationResponse?.isSuccess == true) {
            Get.back(result: true); // Close the dialog and continue the execution
          } else {
            errorAnimationController.add(ErrorAnimationType.shake);
          }
        },
        errorAnimationController: errorAnimationController,
      );
    },
  );
}
