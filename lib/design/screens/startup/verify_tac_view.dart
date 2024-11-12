// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';

class TACVerificationView extends StatelessWidget {
  final String? email;
  const TACVerificationView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyTACController>(
      init: VerifyTACController(email: email),
      builder: (controller) {
        return Material(
          color: const Color.fromRGBO(0, 0, 0, 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: selectIcon(
                    AppIcons.close,
                    width: 30,
                    onPressed: Get.back,
                    color: getColorWhiteBlack,
                  ),
                ).paddingOnly(top: 15),
                const SizedBox(height: 10),
                Text(
                  'A 6-digit code has been sent to your email. Please check your inbox and spam to get the code.',
                  textAlign: TextAlign.center,
                  style: TextThemeX.text16.copyWith(color: getLightGold),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  cursorWidth: 1,
                  cursorHeight: 20,
                  hintCharacter: '-',
                  appContext: context,
                  keyboardType: TextInputType.number,
                  focusNode: controller.otpFocusNode,
                  animationType: AnimationType.scale,
                  textStyle: TextThemeX.text20.copyWith(
                    color: getPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    borderWidth: 1,
                    fieldWidth: 50,
                    fieldHeight: 50,
                    activeColor: green,
                    shape: PinCodeFieldShape.box,
                    selectedColor: getPrimaryColor,
                    inactiveColor: getOutlineColor,
                    borderRadius: BorderRadius.circular(10),
                    errorBorderColor: lightRed.withOpacity(.5),
                  ),
                  onChanged: (_) {},
                  onCompleted: controller.onTACVerify,
                  controller: controller.otpController,
                  errorAnimationController: controller.otpErrorController,
                ),
                const SizedBox(height: 8),
                Text(
                  'Note: The code is valid for 30 minutes. Requesting a new code will expire the previous code.',
                  style: TextThemeX.text14,
                ),
              ],
            ).paddingOnly(bottom: 20).defaultContainer(hP: 12, vP: 0).paddingOnly(bottom: 30),
          ),
        );
      },
    );
  }
}

class VerifyTACController extends GetxController {
  final String? email;
  VerifyTACController({this.email});

  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  FocusNode otpFocusNode = FocusNode();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> otpErrorController = StreamController<ErrorAnimationType>();

  Future<void> onTACVerify(_) async {
    final GetResponseModel? response =
        await _homeRepository.verifyTACCode(code: otpController.text, email: email);

    if (response?.isSuccess == true) {
      await showSuccessDialog(successMessage: response?.message);
      Get.back(result: true);
    } else {
      otpErrorController.add(ErrorAnimationType.shake);
    }
  }
}
