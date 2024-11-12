import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/withdraw_fund_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class WithdrawFundView extends StatelessWidget {
  const WithdrawFundView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawFundController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.withdrawFund),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              "Wallet Balance: ",
                              style: TextThemeX.text14.copyWith(color: getGrey1),
                            ),
                            const SizedBox(width: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(
                                  controller.walletDetails?.qmCashWallet?.cashBalanceInCurrency ??
                                      na,
                                  style: TextThemeX.text14.copyWith(
                                    color: getPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CText(
                                  controller
                                          .walletDetails?.qmCashWallet?.baseCashBalanceInCurrency ??
                                      na,
                                  style: TextThemeX.text12.copyWith(color: getColorWhiteBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: controller.formKey,
                          child: CTextField(
                            labelText: "Withdrawal Amount",
                            controller: controller.withdrawAmountController,
                            inputFormatters: [CTextField.decimalFormatter],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (isNullEmptyOrFalse(value)) {
                                return "required!";
                              } else if (double.parse(value!) >
                                  controller
                                      .walletDetails!.qmCashWallet!.cashBalanceInCurrencyVal!) {
                                return "Insufficient balance!";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        CFlatButton(
                          text: "Review",
                          onPressed: controller.onReview,
                        ).defaultHorizontal,
                      ],
                    ).defaultHorizontal,
                  ),
                ),
        );
      },
    );
  }
}
