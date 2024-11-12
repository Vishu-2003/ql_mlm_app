// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/utils/utils.dart';

class OTPVerificationView extends StatelessWidget {
  final Function(String)? onCompleted;
  final StreamController<ErrorAnimationType>? errorAnimationController;

  const OTPVerificationView({
    super.key,
    required this.onCompleted,
    required this.errorAnimationController,
  });

  @override
  Widget build(BuildContext context) {
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
              onCompleted: onCompleted,
              errorAnimationController: errorAnimationController,
            ),
          ],
        ).paddingOnly(bottom: 20).defaultContainer(hP: 12, vP: 0).paddingOnly(bottom: 30),
      ),
    );
  }
}
