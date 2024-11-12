import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/float_account/deposit_fund_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class DepositFundView extends StatelessWidget {
  const DepositFundView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositFundController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.depositFund),
          body: controller.isLoading
              ? defaultLoader()
              : Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CTextField(
                        controller: controller.amountController,
                        validator: AppValidator.numberValidator,
                        inputFormatters: [CTextField.decimalFormatter],
                        labelText: TranslationController.td.depositAmount,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 24),
                      CPullDownButton<({PaymentMode? mode, bool attachmentRequired})>(
                        hint: TranslationController.td.paymentMethod,
                        selectedItem: controller.selectedPaymentMethod,
                        items: controller.paymentMethods
                            .map((method) => (item: method.mode?.value ?? na, data: method))
                            .toList(),
                        onChanged: controller.onPaymentMethodSelected,
                      ),
                      if (controller.selectedPaymentMethod?.data.attachmentRequired == true) ...[
                        const SizedBox(height: 24),
                        CFlatButton(
                          bgColor: getBg2,
                          text: "Upload file",
                          sufficIcon: AppIcons.arrowUp,
                          textColor: getColorWhiteBlack,
                          onPressed: controller.pickFile,
                          border: Border.all(color: outline),
                        ),
                        if (!isNullEmptyOrFalse(controller.attachment?.name))
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CText(
                              controller.attachment?.name ?? '',
                              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                            ).paddingOnly(left: 10, top: 6),
                          ),
                      ],
                      const SizedBox(height: 40),
                      CFlatButton(
                        onPressed: controller.onDeposit,
                        text: TranslationController.td.proceed,
                      ).defaultHorizontal,
                    ],
                  ).defaultHorizontal,
                ),
        );
      },
    );
  }
}
