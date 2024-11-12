import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/qr_scanner/merchant_payment_controller.dart';
import '/utils/utils.dart';

class MerchantPaymentView extends StatelessWidget {
  const MerchantPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MerchantPaymentController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: 'Merchant Payment'),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              networkImage(
                                width: 55,
                                borderRadius: 8,
                                imageUrl: controller.merchantDetails?.profile,
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.merchantDetails?.merchantName ?? na,
                                      style: TextThemeX.text18.copyWith(
                                        color: getColorWhiteBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      controller.merchantDetails?.merchantAddress ?? na,
                                      style: TextThemeX.text14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).defaultContainer(
                            hP: 12,
                            vP: 12,
                            backgroundColor: getPrimaryColor.withOpacity(.1),
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => CTextField(
                              labelText: "Payable Amount",
                              textInputAction: TextInputAction.done,
                              onChanged: controller.onAmountChanged,
                              controller: controller.amountController,
                              validator: AppValidator.numberValidator,
                              inputFormatters: [CTextField.decimalFormatter],
                              suffixIcon: controller.loadingGoldConvertAmount.value
                                  ? CupertinoActivityIndicator(color: getPrimaryColor)
                                  : null,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CCoreButton(
                            onPressed: () => controller.onBalanceChecked(
                              isGCA: controller.useGCABalance.isUsed,
                              isFloat: !controller.useFloatBalance.isUsed,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  controller.useFloatBalance.isUsed
                                      ? CupertinoIcons.checkmark_square_fill
                                      : CupertinoIcons.square,
                                ).paddingOnly(right: 10, top: 3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CText(
                                      "Use Float Account Balance",
                                      style: TextThemeX.text14
                                          .copyWith(fontSize: 15, color: getColorWhiteBlack),
                                    ),
                                    const SizedBox(height: 5),
                                    CText(
                                      "Available Balance: ${controller.availableBalance?.cashBalanceInCurrency ?? na}",
                                      style: TextThemeX.text14.copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ).defaultContainer(
                              hM: 0,
                              vP: 10,
                              hP: 10,
                              border: controller.useFloatBalance.isUsed
                                  ? Border.all(color: getPrimaryColor)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CCoreButton(
                            onPressed: () => controller.onBalanceChecked(
                              isFloat: controller.useFloatBalance.isUsed,
                              isGCA: !controller.useGCABalance.isUsed,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  controller.useGCABalance.isUsed
                                      ? CupertinoIcons.checkmark_square_fill
                                      : CupertinoIcons.square,
                                ).paddingOnly(right: 10, top: 3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CText(
                                      "Use Gold Convert Balance",
                                      style: TextThemeX.text14
                                          .copyWith(fontSize: 15, color: getColorWhiteBlack),
                                    ),
                                    const SizedBox(height: 5),
                                    CText(
                                      "Available GSA Balance: ${controller.availableBalance?.gsaHoldingInCurrency ?? na}",
                                      style: TextThemeX.text12,
                                    ),
                                    const SizedBox(height: 5),
                                    CText(
                                      "Available Gold Converted Value: ${controller.availableBalance?.gsaHoldingConvertedValueInCurrency ?? na}",
                                      style: TextThemeX.text14.copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ).defaultContainer(
                              hM: 0,
                              vP: 10,
                              hP: 10,
                              border: controller.useGCABalance.isUsed
                                  ? Border.all(color: getPrimaryColor)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Column(
                            children: [
                              if (kDebugMode) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText("Float Balance", style: TextThemeX.text14),
                                    CText(
                                      controller.useFloatBalance.isUsed
                                          ? "- ${controller.useFloatBalance.amount}"
                                          : "- 0.0",
                                      style: TextThemeX.text14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CText("GCA Balance", style: TextThemeX.text14),
                                    CText(
                                      controller.useGCABalance.isUsed
                                          ? "- ${controller.useGCABalance.amount}"
                                          : "- 0.0",
                                      style: TextThemeX.text14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CText("Remaining Payable Amount", style: TextThemeX.text14),
                                  CText(
                                    controller.calculateRemainingPayableAmount().toStringAsFixed(2),
                                    style: TextThemeX.text14,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CText(
                                    "Required Gold Purchase",
                                    style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                                  ),
                                  CText(
                                    controller.goldConvertAmount?.actualAmountInCurrency ?? "0.0",
                                    style: TextThemeX.text16.copyWith(color: getPrimaryColor),
                                  ),
                                ],
                              ),
                            ],
                          ).defaultContainer(hM: 0, vP: 10),
                        ],
                      ).defaultHorizontal,
                    ),
                  ),
                ),
          bottomNavigationBar: controller.isLoading
              ? null
              : CFlatButton(
                  text: "Pay",
                  onPressed: controller.onPay,
                ).bottomNavBarButton(context),
        );
      },
    );
  }
}
