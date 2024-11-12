import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

Future<void> showConfirmationDialog({
  required String title,
  required String substitle,
  Widget? bottomChild,
  String? dialogImage,
  String positiveButtonTitle = "Yes",
  String negativeButtonTitle = "Cancel",
  VoidCallback? onPositiveButtonPressed,
  VoidCallback? onNegativeButtonPressed,
}) async {
  return await showAdaptiveDialog(
    context: Get.context!,
    barrierDismissible: true,
    barrierColor: getDialogBarrierColor,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            decoration: BoxDecoration(
              color: getOutlineColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  selectImage(dialogImage ?? AppImages.cautionCircle, width: 55),
                  const SizedBox(height: 14),
                  CText(
                    title,
                    style: TextThemeX.text16.copyWith(
                      color: getColorWhiteBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CText(
                    substitle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextThemeX.text14.copyWith(color: getGrey1),
                  ),
                  bottomChild ?? const SizedBox.shrink(),
                  const SizedBox(height: 24),
                  CFlatButton(
                    bgColor: getPrimaryColor,
                    text: positiveButtonTitle,
                    onPressed: onPositiveButtonPressed,
                  ),
                  const SizedBox(height: 16),
                  CFlatButton(
                    text: negativeButtonTitle,
                    textColor: getPrimaryColor,
                    bgColor: Colors.transparent,
                    border: Border.all(color: getPrimaryColor),
                    onPressed: onNegativeButtonPressed ?? Get.back,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showSuccessDialog({
  String? title,
  String? buttonTitle,
  BuildContext? context,
  VoidCallback? onButtonPressed,
  required String? successMessage,
}) async {
  return await showAdaptiveDialog(
    barrierDismissible: false,
    context: context ?? Get.context!,
    barrierColor: getDialogBarrierColor,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            decoration: BoxDecoration(
              color: getOutlineColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectImage(AppImages.checked, width: 70),
                const SizedBox(height: 16),
                CText(
                  title ?? TranslationController.td.success,
                  style: TextThemeX.text16.copyWith(
                    color: getColorWhiteBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isNullEmptyOrFalse(successMessage)) ...[
                  const SizedBox(height: 4),
                  CText(
                    successMessage!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextThemeX.text16.copyWith(color: getGrey1),
                  ),
                ],
                const SizedBox(height: 24),
                CFlatButton(
                  bgColor: getPrimaryColor,
                  onPressed: onButtonPressed ?? Get.back,
                  text: buttonTitle ?? TranslationController.td.done,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
