import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_tab.dart';
import '/design/screens/dashobard/tabs/home/select_trade_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class SelectTradeView extends StatelessWidget {
  const SelectTradeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectTradeController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          appBar: CAppBar(title: "${TranslationController.td.sell} ${controller.item?.itemName}"),
          body: controller.isLoading
              ? defaultLoader()
              : Column(
                  children: [
                    const GoldPrice(),
                    const SizedBox(height: 16),
                    controller.goldContracts.isEmpty
                        ? noDataAvailableCard(text: "You don't have any gold contracts !")
                            .defaultHorizontal
                        : Form(
                            key: controller.contractAutoTradeFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Row(
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
                                      value: controller.autoTradeContract,
                                      onChanged: controller.onAutoTradeContractChanged,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                if (controller.autoTradeContract)
                                  Expanded(
                                    child: CTextField(
                                      validator: AppValidator.numberValidator,
                                      labelText: TranslationController.td.goldRate,
                                      inputFormatters: [CTextField.decimalFormatter],
                                      controller: controller.autoTradeContractRateController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(decimal: true),
                                    ),
                                  ),
                              ],
                            ).defaultHorizontal,
                          ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.goldContracts.length,
                        padding:
                            EdgeInsets.only(bottom: context.bottomPadding + flatButtonHeight + 24),
                        itemBuilder: (context, index) {
                          return _GoldCard(controller.goldContracts[index]);
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                      ).defaultHorizontal,
                    ),
                  ],
                ),
          bottomNavigationBar: CFlatButton(
            textColor: getPrimaryColor,
            onPressed: controller.onNext,
            bgColor: Colors.transparent,
            text: TranslationController.td.next,
            border: Border.all(color: getPrimaryColor),
            isDisabled: controller.selectedGoldContracts.isEmpty,
          ).bottomNavBarButton(context),
        );
      },
    );
  }
}

class _GoldCard extends StatelessWidget {
  final GetGoldContractModel contract;
  const _GoldCard(this.contract);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectTradeController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () => controller.onGoldContractSelected(contract),
          child: Stack(
            children: [
              GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CText(
                          contract.id,
                          style: TextThemeX.text16.copyWith(color: lightGold),
                        ),
                        CText(
                          " (${attachUnit(contract.estimatedGold ?? na)})",
                          style: TextThemeX.text16.copyWith(
                            color: getPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailsRow(
                          "${TranslationController.td.purchaseDate}: ",
                          contract.purchaseDate ?? na,
                        ),
                        const SizedBox(height: 5),
                        detailsRow(
                          "${TranslationController.td.purchasedAmount}: ",
                          contract.purchaseAmount ?? na,
                          valueColor: getPrimaryColor,
                          value2: contract.basePurchaseAmount ?? na,
                        ),
                        const SizedBox(height: 5),
                        detailsRow(
                          "${TranslationController.td.sellAmount}: ",
                          contract.sellingAmount ?? na,
                          valueColor: getPrimaryColor,
                          value2: contract.baseSellingAmount ?? na,
                        ),
                        const SizedBox(height: 5),
                        detailsRow("${TranslationController.td.fees}: ", contract.fees ?? na),
                        const SizedBox(height: 5),
                        detailsRow(
                          "${TranslationController.td.profit} / ${TranslationController.td.loss}: ",
                          contract.profitLoss ?? na,
                          valueColor:
                              contract.profitLossVal?.isNegative ?? false ? lightRed : green,
                        ),
                      ],
                    ),
                  ],
                ).defaultContainer(hM: 0),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: controller.selectedGoldContracts.contains(contract)
                      ? getPrimaryColor
                      : getGrey1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row detailsRow(String title, String value, {Color? valueColor, String? value2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CText(
            title,
            overflow: TextOverflow.visible,
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                value,
                overflow: TextOverflow.visible,
                style: TextThemeX.text14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? getColorWhiteBlack,
                ),
              ),
              if (value2 != null)
                CText(
                  value2,
                  style: TextThemeX.text12.copyWith(color: getColorWhiteBlack),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
