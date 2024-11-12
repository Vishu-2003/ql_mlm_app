import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/wallet/wallet_tab.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_tab.dart';
import '/design/screens/dashobard/tabs/home/sell_gold_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class SellGoldView extends StatelessWidget {
  const SellGoldView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellGoldController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: "${TranslationController.td.sell} ${controller.item?.itemName}"),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: Column(
                    children: [
                      const GoldPrice(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: defaultScrollablePhysics,
                          child: controller.isSellGoldContract
                              ? const _ContractGold().defaultHorizontal
                              : const _NormalGold().defaultHorizontal,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ContractGold extends StatelessWidget {
  const _ContractGold();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellGoldController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Column(
              children: controller.sellOrderDetails?.responseTotal
                      ?.map((data) => _DetailRow(data: data).paddingOnly(bottom: 24))
                      .toList() ??
                  [],
            ),
            const SizedBox(height: 20),
            const _PricingTimer().defaultHorizontal,
            const SizedBox(height: 12),
            CFlatButton(
              text: TranslationController.td.sell,
              onPressed: controller.sellContractGold,
              isDisabled: controller.sellOrderDetails == null,
            ).defaultHorizontal,
            if (!isNullEmptyOrFalse(controller.item?.terms)) ...[
              const SizedBox(height: 10),
              CText(
                controller.item?.terms ?? na,
                style: TextThemeX.text14.copyWith(color: getGrey1),
              ),
            ],
            SizedBox(height: context.bottomPadding),
          ],
        );
      },
    );
  }
}

class _NormalGold extends StatelessWidget {
  const _NormalGold();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellGoldController>(
      builder: (controller) {
        return Form(
          key: controller.normalGoldFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Column(
                children: [
                  TitleValueRow(
                    "Gold Holding",
                    attachUnit(controller.wallet?.qmGsaWallet?.holdingWeight),
                  ),
                  const SizedBox(height: 16),
                  TitleValueRow(
                    "Current Value\n(${TranslationController.td.baseOnGoldSpotPrice})",
                    controller.wallet?.qmGsaWallet?.holdingValueInCurrency ?? na,
                    value2: controller.wallet?.qmGsaWallet?.baseHoldingValueInCurrency ?? na,
                  ),
                ],
              ).defaultContainer(hM: 0),
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
              const SizedBox(height: 16),
              if (controller.isAmountSelected) ...[
                CTextField(
                  onChanged: controller.onAmountChanged,
                  validator: AppValidator.numberValidator,
                  inputFormatters: [CTextField.decimalFormatter],
                  labelText: TranslationController.td.goldSellAmount,
                  controller: controller.normalGoldAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
              if (!controller.isAmountSelected) ...[
                CTextField(
                  onChanged: controller.onGramChanged,
                  validator: AppValidator.numberValidator,
                  inputFormatters: [CTextField.decimalFormatter],
                  controller: controller.normalGoldGramController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  labelText: "${TranslationController.td.weight} (${TranslationController.td.g})",
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Row(
                    children: [
                      CText(
                        TranslationController.td.autoTrade,
                        style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                      ),
                      const SizedBox(width: 10),
                      Switch.adaptive(
                        value: controller.autoTrade,
                        activeColor: getPrimaryColor,
                        onChanged: controller.onAutoTradeToggled,
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  if (controller.autoTrade)
                    Expanded(
                      child: CTextField(
                        validator: AppValidator.numberValidator,
                        labelText: TranslationController.td.goldRate,
                        inputFormatters: [CTextField.decimalFormatter],
                        onChanged: controller.onGoldRateAutoTradeChanged,
                        controller: controller.autoTradeGoldRateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                ],
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
                onPressed: controller.getGoldSellOrderDetails,
              ),
              Divider(color: getOutlineColor, height: 40),
              Column(
                children: controller.sellOrderDetails?.responseTotal
                        ?.map((data) => _DetailRow(data: data).paddingOnly(bottom: 24))
                        .toList() ??
                    [],
              ),
              if (controller.sellOrderDetails != null) ...[
                const _PricingTimer().defaultHorizontal,
                const SizedBox(height: 12),
                CFlatButton(
                  text: TranslationController.td.sell,
                  onPressed: controller.sellNormalGold,
                ).defaultHorizontal,
                if (!isNullEmptyOrFalse(controller.item?.terms)) ...[
                  const SizedBox(height: 10),
                  CText(
                    controller.item?.terms ?? na,
                    style: TextThemeX.text14.copyWith(color: getGrey1),
                  ),
                ],
              ],
              SizedBox(height: context.bottomPadding),
            ],
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final ({String? title, String? value, String? value2}) data;
  const _DetailRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CText(
          data.title ?? na,
          style: TextThemeX.text14.copyWith(color: getGrey1),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CText(
              data.value ?? na,
              style: TextThemeX.text14.copyWith(
                color: getPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            CText(data.value2 ?? na, style: TextThemeX.text12.copyWith(color: getGrey1)),
          ],
        ),
      ],
    );
  }
}

class _PricingTimer extends GetWidget<SellGoldController> {
  const _PricingTimer();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: controller.stopWatchTimer.rawTime,
      builder: (context, snapshot) {
        final int? value = snapshot.data;
        final String displayTime =
            StopWatchTimer.getDisplayTime(value ?? 2, hours: false, milliSecond: false);
        return CText(
          "${TranslationController.td.yourPricingExpiresIn} $displayTime",
          style: TextThemeX.text14.copyWith(
            fontWeight: FontWeight.w600,
            color: getPrimaryTextColor,
          ),
        );
      },
    );
  }
}
