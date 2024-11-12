import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/design/components/components.dart';
import '/design/screens/startup/otp_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class OTPView extends GetWidget<OtpController> {
  const OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(title: TranslationController.td.oTPVerification),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CText(
            '${TranslationController.td.needToVerifyOTPSentOnYourMobileNumberWeHaveSentaVerificationCodeTo} ${controller.mobileNumber}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextThemeX.text16.copyWith(color: getPrimaryTextColor),
          ),
          const SizedBox(height: 30),
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
            controller: controller.otpController,
            errorAnimationController: controller.otpErrorController,
            onChanged: (_) {},
            onCompleted: (_) {
              controller.verifyOtp(controller.otpController.text);
            },
          ),
          const SizedBox(height: 30),
          CFlatButton(
            text: TranslationController.td.verify,
            onPressed: () => controller.verifyOtp(controller.otpController.text),
          ).defaultHorizontal,
          const SizedBox(height: 20),
          // TODO: Add Resend OTP timer
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CText(
          //       LocaleKeys.resend_code_in.tr,
          //       style: TextThemeX.text16.copyWith(
          //         letterSpacing: 0.3,
          //         color: getColor1,
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //     CText(
          //       ' 00:22',
          //       style: TextThemeX.text16.copyWith(
          //         letterSpacing: 0.3,
          //         color: getPrimaryTextColor,
          //         fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ).defaultHorizontal,
    );
  }
}
