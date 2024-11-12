import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/buy_gold_controller.dart';
import '/design/screens/dashobard/tabs/home/home_tab.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class BuyGoldView extends StatelessWidget {
  const BuyGoldView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyGoldController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: "${TranslationController.td.buy} ${controller.item?.itemName}"),
          body: SizedBox.expand(
            child: Column(
              children: [
                const GoldPrice(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: controller.item?.itemType == "Gold"
                        ? const _NormalGold().defaultHorizontal
                        : const _ContractGold().defaultHorizontal,
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

class _NormalGold extends StatelessWidget {
  const _NormalGold();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyGoldController>(
      builder: (controller) {
        bool hasEnoughBalance = (controller.wallet?.qmCashWallet?.cashBalanceInCurrencyVal ?? 0) >=
            (controller.buyOrderDetails?.orderDoc['down_payment'] ?? 0);
        return Form(
          key: controller.normalGoldFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _WalletBalance(hasEnoughBalance: hasEnoughBalance),
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
                  labelText: TranslationController.td.amount,
                  controller: controller.normalGoldAmountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final String? errorMessage = AppValidator.numberValidator(value);
                    if (errorMessage != null) return errorMessage;

                    if ((controller.item?.unitPriceVal ?? 0) >
                            (double.tryParse(value ?? "0") ?? 0) &&
                        controller.normalGoldGramController.text.isEmpty) {
                      return "${TranslationController.td.minimumOrderAmountIs} ${controller.item?.unitPriceVal ?? na} (${controller.item?.baseUnitPrice ?? na})";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: CText(
                    "${TranslationController.td.minimumOrderAmountIs} ${controller.item?.unitPrice ?? na} (${controller.item?.baseUnitPrice ?? na})",
                    style: TextThemeX.text12.copyWith(color: getdarkGColor),
                  ),
                ),
              ],
              if (!controller.isAmountSelected) ...[
                CTextField(
                  onChanged: controller.onGramChanged,
                  controller: controller.normalGoldGramController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  labelText: "${TranslationController.td.weight} (${TranslationController.td.g})",
                  validator: (value) {
                    final String? errorMessage = AppValidator.numberValidator(value);
                    if (errorMessage != null) return errorMessage;

                    if ((controller.item?.estimatedGold ?? 0) >
                            (double.tryParse(value ?? "0") ?? 0) &&
                        controller.normalGoldAmountController.text.isEmpty) {
                      return "${TranslationController.td.minimumOrderGramIs} ${controller.item?.estimatedGold ?? na}";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: CText(
                    "${TranslationController.td.minimumOrderGramIs} ${controller.item?.estimatedGold ?? na}",
                    style: TextThemeX.text12.copyWith(color: getdarkGColor),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CText(
                        TranslationController.td.autoTrade,
                        style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                      ),
                      const SizedBox(width: 10),
                      Switch.adaptive(
                        activeColor: getPrimaryColor,
                        value: controller.autoTradeGoldRate,
                        onChanged: controller.onGoldRateAutoTradeToggle,
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  if (controller.autoTradeGoldRate)
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
                onPressed: controller.getGoldBuyOrderDetails,
              ),
              Divider(color: getOutlineColor, height: 40),
              Column(
                children: controller.buyOrderDetails?.responseTotal
                        ?.map((data) => _DetailRow(data: data).paddingOnly(bottom: 24))
                        .toList() ??
                    [],
              ),
              if (!hasEnoughBalance) ...[
                CFlatButton(
                  bgColor: getBg1,
                  textColor: getPrimaryColor,
                  onPressed: controller.addFund,
                  text: TranslationController.td.addFund,
                  border: Border.all(color: getPrimaryColor),
                ).defaultHorizontal,
                const SizedBox(height: 16),
              ],
              if (hasEnoughBalance && controller.buyOrderDetails != null) ...[
                const _PricingTimer().defaultHorizontal,
                const SizedBox(height: 20),
                CFlatButton(
                  isDisabled: !hasEnoughBalance,
                  onPressed: controller.buyNormalGold,
                  text: TranslationController.td.buy,
                ).defaultHorizontal,
              ],
              if (!isNullEmptyOrFalse(controller.item?.terms)) ...[
                const SizedBox(height: 10),
                CText(
                  controller.item?.terms ?? na,
                  style: TextThemeX.text14.copyWith(color: getGrey1),
                ),
              ],
              SizedBox(height: context.bottomPadding),
            ],
          ),
        );
      },
    );
  }
}

class _WalletBalance extends StatelessWidget {
  final bool hasEnoughBalance;

  const _WalletBalance({required this.hasEnoughBalance});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyGoldController>(
      builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              "${TranslationController.td.walletBalance}: ",
              style: TextThemeX.text14.copyWith(color: hasEnoughBalance ? green : lightRed),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  controller.wallet?.qmCashWallet?.cashBalanceInCurrency ?? na,
                  style: TextThemeX.text14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasEnoughBalance ? green : lightRed,
                  ),
                ),
                CText(
                  controller.wallet?.qmCashWallet?.baseCashBalanceInCurrency ?? na,
                  style: TextThemeX.text12.copyWith(
                    color: hasEnoughBalance ? green : lightRed,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PricingTimer extends GetWidget<BuyGoldController> {
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

class _ContractGold extends StatelessWidget {
  const _ContractGold();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyGoldController>(
      builder: (controller) {
        bool hasEnoughBalance = (controller.wallet?.qmCashWallet?.cashBalanceInCurrencyVal ?? 0) >=
            (controller.buyOrderDetails?.orderDoc['down_payment'] ?? 0);
        return Form(
          key: controller.contractGoldFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _WalletBalance(hasEnoughBalance: hasEnoughBalance),
              const SizedBox(height: 24),
              CTextField(
                onChanged: controller.onUnitChanged,
                validator: AppValidator.numberValidator,
                labelText: TranslationController.td.numberOfUnit,
                controller: controller.contractGoldUnitController,
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
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
                        value: controller.autoTradeGoldRate,
                        activeColor: getPrimaryColor,
                        onChanged: controller.onUnitRateAutoTradeToogle,
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  if (controller.autoTradeGoldRate)
                    Expanded(
                      child: CTextField(
                        validator: AppValidator.numberValidator,
                        labelText: TranslationController.td.goldRate,
                        inputFormatters: [CTextField.decimalFormatter],
                        onChanged: controller.onUnitRateAutoTradeChanged,
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
                onPressed: controller.getContractBuyOrderDetails,
              ),
              Divider(color: getOutlineColor, height: 40),
              Column(
                children: controller.buyOrderDetails?.responseTotal
                        ?.map((data) => _DetailRow(data: data).paddingOnly(bottom: 24))
                        .toList() ??
                    [],
              ),
              if (!hasEnoughBalance) ...[
                CText(
                  "Insufficient Balance",
                  style: TextThemeX.text14.copyWith(color: hasEnoughBalance ? green : lightRed),
                ).defaultHorizontal,
                const SizedBox(height: 10),
                CFlatButton(
                  text: TranslationController.td.addFund,
                  bgColor: getBg1,
                  textColor: getPrimaryColor,
                  onPressed: controller.addFund,
                  border: Border.all(color: getPrimaryColor),
                ).defaultHorizontal,
                const SizedBox(height: 16),
              ],
              if (hasEnoughBalance && controller.buyOrderDetails != null) ...[
                const _PricingTimer().defaultHorizontal,
                const SizedBox(height: 20),
                CFlatButton(
                  isDisabled: !hasEnoughBalance,
                  onPressed: controller.buyContract,
                  text: TranslationController.td.buy,
                ).defaultHorizontal,
              ],
              if (!isNullEmptyOrFalse(controller.item?.terms)) ...[
                const SizedBox(height: 10),
                CText(
                  controller.item?.terms ?? na,
                  style: TextThemeX.text14.copyWith(color: getGrey1),
                ),
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
