import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/withdraw_fund_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class WithdrawFundDetailsView extends StatelessWidget {
  const WithdrawFundDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawFundController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.withdrawFundReview),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _detailColumn(
                    TranslationController.td.withdrawalAmount,
                    "${controller.withdrawalInformation?.amount ?? na}",
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.withdrawalFees,
                    "${controller.withdrawalInformation?.charges ?? na} (${controller.withdrawalInformation?.chargesPercentage ?? na}%)",
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.youWillReceive,
                    "${controller.withdrawalInformation?.actualAmount ?? na}",
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.bankName,
                    controller.withdrawalInformation?.bankName ?? na,
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.accountHolderName,
                    controller.withdrawalInformation?.bankAccountHolderName ?? na,
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.accountNumber,
                    controller.withdrawalInformation?.accountNumber ?? na,
                  ),
                  const SizedBox(height: 12),
                  _detailColumn(
                    TranslationController.td.swiftCode,
                    controller.withdrawalInformation?.ifscCode ?? na,
                  ),
                  const SizedBox(height: 40),
                  CFlatButton(
                    onPressed: controller.onFundWithdraw,
                    text: TranslationController.td.withdraw,
                  ).defaultHorizontal,
                ],
              ).defaultHorizontal,
            ),
          ),
        );
      },
    );
  }

  Column _detailColumn(String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CText(
          key,
          style: TextThemeX.text12.copyWith(color: getGrey1),
        ),
        const SizedBox(height: 2),
        CText(
          value,
          style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
        ),
      ],
    );
  }
}
