import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_transfer_controller.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_tab.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class GoldTransferView extends StatelessWidget {
  const GoldTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldTransferController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: 'Gold Transfer'),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Column(
                            children: [
                              TitleValueRow(
                                "Gold Holding",
                                attachUnit(
                                    controller.getGoldWalletDetails?.balanceBeforeRequestInValue),
                              ),
                              const SizedBox(height: 16),
                              TitleValueRow(
                                "Current Value\n(${TranslationController.td.baseOnGoldSpotPrice})",
                                controller.getGoldWalletDetails?.balanceBeforeRequest ?? na,
                                value2:
                                    controller.getGoldWalletDetails?.baseBalanceBeforeRequest ?? na,
                              ),
                            ],
                          ).defaultContainer(hM: 0),
                          const SizedBox(height: 12),
                          CFlatButton(
                            height: 40,
                            fontSize: 14,
                            borderRadius: 8,
                            bgColor: getBg1,
                            textColor: getPrimaryColor,
                            onPressed: controller.addRecipient,
                            border: Border.all(color: getPrimaryColor),
                            text: TranslationController.td.addRecipient,
                          ),
                          const SizedBox(height: 30),
                          CSelectionSheetField(
                            labelText: "To Account*",
                            sheetTitle: "Select Recipient",
                            items: controller.beneficiaryList
                                .map((e) => SelectionSheetItem(
                                      id: e.beneficiaryMember,
                                      title: e.beneficiaryMember,
                                      subtitle: e.beneficiaryName,
                                    ))
                                .toList(),
                            onSelected: controller.onBeneficiaryChanged,
                            selectedItems: [
                              if (controller.selectedBeneficiary != null)
                                controller.selectedBeneficiary!
                            ],
                            controller:
                                TextEditingController(text: controller.selectedBeneficiary?.id),
                          ),
                          if (controller.selectedBeneficiary != null) ...[
                            const SizedBox(height: 16),
                            CTextField(
                              enabled: false,
                              labelText: "Recipient Name",
                              controller: TextEditingController(
                                text: controller.selectedBeneficiary?.subtitle,
                              ),
                            ),
                          ],
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
                          controller.isAmountSelected
                              ? CTextField(
                                  labelText: "Amount*",
                                  controller: controller.amountController,
                                  validator: AppValidator.numberValidator,
                                  inputFormatters: [CTextField.decimalFormatter],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                )
                              : CTextField(
                                  controller: controller.gramController,
                                  validator: AppValidator.numberValidator,
                                  inputFormatters: [CTextField.decimalFormatter],
                                  labelText:
                                      "${TranslationController.td.weight} (${TranslationController.td.g})*",
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                ),
                          const SizedBox(height: 16),
                          CTextField(
                            maxLines: 3,
                            minLines: null,
                            labelText: "Description",
                            keyboardType: TextInputType.text,
                            controller: controller.descriptionController,
                          ),
                        ],
                      ).defaultHorizontal,
                    ),
                  ),
                ),
          bottomNavigationBar: controller.isLoading
              ? null
              : CFlatButton(
                  text: "Transfer",
                  onPressed: controller.onTransfer,
                ).bottomNavBarButton(context),
        );
      },
    );
  }
}
