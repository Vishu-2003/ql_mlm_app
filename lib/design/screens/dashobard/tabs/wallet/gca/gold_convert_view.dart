import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_controller.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_tab.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class GoldConvertView extends StatelessWidget {
  const GoldConvertView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldConvertController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.convertGold),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _GoldCard(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CCoreButton(
                              onPressed: () {
                                controller.onChanged(true);
                              },
                              child: Row(
                                children: [
                                  Radio<bool>.adaptive(
                                    value: true,
                                    activeColor: getPrimaryColor,
                                    onChanged: controller.onChanged,
                                    groupValue: controller.isAmountSelected,
                                  ),
                                  const SizedBox(width: 6),
                                  CText(
                                    "Amount",
                                    style: TextThemeX.text14.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            CCoreButton(
                              onPressed: () {
                                controller.onChanged(false);
                              },
                              child: Row(
                                children: [
                                  Radio<bool>.adaptive(
                                    value: false,
                                    activeColor: getPrimaryColor,
                                    onChanged: controller.onChanged,
                                    groupValue: controller.isAmountSelected,
                                  ),
                                  const SizedBox(width: 6),
                                  CText(
                                    "Gram",
                                    style: TextThemeX.text14.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Form(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: controller.isAmountSelected
                              ? CTextField(
                                  onChanged: controller.onAmountChanged,
                                  controller: controller.amountController,
                                  labelText: TranslationController.td.amount,
                                  inputFormatters: [CTextField.decimalFormatter],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                  validator: (value) {
                                    final String? errorMessage =
                                        AppValidator.numberValidator(value);
                                    if (errorMessage != null) return errorMessage;

                                    if ((double.tryParse(controller.amountController.text.trim()) ??
                                            0) >
                                        (controller
                                                .wallet?.qmGcaWallet?.availableGoldInCurrencyVal ??
                                            0)) {
                                      return TranslationController
                                          .td.youDontHaveEnoughGoldToConvert;
                                    }
                                    return null;
                                  },
                                )
                              : CTextField(
                                  onChanged: controller.onWeightChanged,
                                  controller: controller.weightController,
                                  inputFormatters: [CTextField.decimalFormatter],
                                  labelText:
                                      "${TranslationController.td.weight} (${TranslationController.td.g})",
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                  validator: (value) {
                                    final String? errorMessage =
                                        AppValidator.numberValidator(value);
                                    if (errorMessage != null) return errorMessage;

                                    if ((double.tryParse(controller.weightController.text.trim()) ??
                                            0) >
                                        (controller.wallet?.qmGcaWallet?.availableGoldWeight ??
                                            0)) {
                                      return TranslationController
                                          .td.youDontHaveEnoughGoldToConvert;
                                    }
                                    return null;
                                  },
                                ),
                        ),
                        const SizedBox(height: 30),
                        CFlatButton(
                          height: 40,
                          fontSize: 14,
                          borderRadius: 8,
                          bgColor: getBg1,
                          text: "Continue",
                          textColor: getPrimaryColor,
                          border: Border.all(color: getPrimaryColor),
                          onPressed: controller.getGSAConvertInformation,
                        ),
                        Divider(color: getOutlineColor, height: 40),
                        Column(
                          children: controller.goldConvertDetails?.responseTotal
                                  ?.map((data) => Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CText(
                                            data.title ?? na,
                                            style: TextThemeX.text14.copyWith(color: getGrey1),
                                          ),
                                          CText(
                                            data.value ?? na,
                                            style: TextThemeX.text14.copyWith(
                                              color: getPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ).paddingOnly(bottom: 24))
                                  .toList() ??
                              [],
                        ),
                        const SizedBox(height: 20),
                        if (controller.goldConvertDetails != null) ...[
                          StreamBuilder<int>(
                            stream: controller.stopWatchTimer.rawTime,
                            builder: (context, snapshot) {
                              final int? value = snapshot.data;
                              final String displayTime = StopWatchTimer.getDisplayTime(value ?? 2,
                                  hours: false, milliSecond: false);
                              return CText(
                                "${TranslationController.td.yourPricingExpiresIn} $displayTime",
                                style: TextThemeX.text14.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: getPrimaryTextColor,
                                ),
                              );
                            },
                          ).defaultHorizontal,
                          const SizedBox(height: 12),
                          CFlatButton(
                            onPressed: controller.onConvert,
                            text: TranslationController.td.convert,
                          ).defaultHorizontal,
                        ],
                      ],
                    ).defaultHorizontal,
                  ),
                ),
        );
      },
    );
  }
}

class _GoldCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldConvertController>(
      builder: (controller) {
        return Column(
          children: [
            TitleValueRow(
              "Available Gold Convert",
              attachUnit(controller.wallet?.qmGcaWallet?.availableGoldWeight),
            ),
            const SizedBox(height: 5),
            TitleValueRow(
              "Available Gold Convert Value",
              controller.wallet?.qmGcaWallet?.availableGoldInCurrency ?? na,
              value2: controller.wallet?.qmGcaWallet?.baseAvailableGoldInCurrency ?? na,
            ),
          ],
        ).defaultContainer(hM: 0);
      },
    );
  }
}
