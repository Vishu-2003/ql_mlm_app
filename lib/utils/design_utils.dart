import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/services/biometric_service.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class DesignUtils {
  static Future<bool?> doBiometricAuth() async {
    BiometricService.authenticate().then((value) {
      if (value) Get.back(result: value);
    });

    return showAdaptiveDialog<bool?>(
      context: Get.context!,
      barrierColor: getBgColor,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Material(
            color: getBgColor,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: context.topPadding),
                  selectImage(AppImages.logo2, width: 175),
                  const Spacer(),
                  selectIcon(AppIcons.lock2, width: 80),
                  const SizedBox(height: 30),
                  Text(
                    "AUTHENTICATION REQUIRED",
                    style: TextThemeX.text14.copyWith(fontSize: 10, letterSpacing: 1),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Because the only person\nseeing your data should be\nyou",
                    textAlign: TextAlign.center,
                    style:
                        TextThemeX.text18.copyWith(color: getLightGold, fontSize: 22, height: 1.3),
                  ),
                  const Spacer(),
                  CFlatButton(
                    text: "Unlock now",
                    onPressed: () async {
                      bool isAuthenticated = await BiometricService.authenticate();
                      if (isAuthenticated) Get.back(result: true);
                    },
                    iconColor: getBgColor,
                    sufficIcon: AppIcons.lock,
                  ),
                  SizedBox(height: context.bottomPadding),
                ],
              ).defaultHorizontal,
            ),
          ),
        );
      },
    );
  }

  static Future<void> copyToClipboard(String? data) async {
    if (isNullEmptyOrFalse(data)) return;

    Clipboard.setData(ClipboardData(text: data!)).then((value) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          backgroundColor: getBg1,
          duration: const Duration(seconds: 2),
          content: Text(
            "Copied to clipboard",
            style: TextThemeX.text16.copyWith(color: getPrimaryColor),
          ),
        ),
      );
    });
  }
}
