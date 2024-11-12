import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/models/gold_physical_withdrawal_model.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/gsa/gold_withdrawal_controller.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_tab.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class GoldWithdrawalView extends StatelessWidget {
  const GoldWithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldWithdrawalController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.physicalGoldWithdrawal),
          body: SizedBox.expand(
            child: controller.isLoading
                ? defaultLoader()
                : SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const _FormStepNavigator(),
                          const SizedBox(height: 12),
                          if (controller.currentStep == 1) ...[
                            TitleValueRow(
                              TranslationController.td.qmMember,
                              controller.getGoldPhysicalWithdrawalData?.qmMember ?? na,
                            ),
                            const SizedBox(height: 16),
                            TitleValueRow(
                              TranslationController.td.memberName,
                              controller.getGoldPhysicalWithdrawalData?.memberName ?? na,
                            ),
                            const SizedBox(height: 16),
                            TitleValueRow(
                              TranslationController.td.goldHolding,
                              attachUnit(
                                controller
                                    .getGoldPhysicalWithdrawalData?.balanceBeforeRequestInValue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TitleValueRow(
                              "${TranslationController.td.currentValue}\n(${TranslationController.td.baseOnGoldSpotPrice})",
                              controller.getGoldPhysicalWithdrawalData?.balanceBeforeRequest ?? na,
                              value2: controller
                                      .getGoldPhysicalWithdrawalData?.baseBalanceBeforeRequest ??
                                  na,
                            ),
                            const SizedBox(height: 24),
                            CPullDownButton<String>(
                              onChanged: controller.onCountryChanged,
                              hint: TranslationController.td.physicalGoldWithdrawal,
                              items: controller.countryList.map((e) => (data: e, item: e)).toList(),
                              selectedItem: (
                                data: controller.countryController.text,
                                item: controller.countryController.text
                              ),
                            ),
                            if (controller.countryController.text.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              CPullDownButton<String>(
                                hint: TranslationController.td.physicalWithdrawalRegion,
                                onChanged: controller.onRegionChanged,
                                items:
                                    controller.regionList.map((e) => (data: e, item: e)).toList(),
                                selectedItem: (
                                  data: controller.regionController.text,
                                  item: controller.regionController.text
                                ),
                              ),
                            ],
                            if (controller.regionController.text.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              CPullDownButton<GetGoldPhysicalWithdrawalBranchModel>(
                                hint: TranslationController.td.physicalWithdrawalBranch,
                                items: controller.branchList
                                    .map((e) => (data: e, item: e.branch ?? na))
                                    .toList(),
                                onChanged: controller.onBranchChanged,
                                selectedItem: (
                                  data: controller.selectedBranch,
                                  item: controller.selectedBranch?.branch
                                ),
                              ),
                            ],
                            if (controller.selectedBranch != null) ...[
                              const SizedBox(height: 16),
                              CTextField(
                                enabled: false,
                                labelText: TranslationController.td.mobileNumber,
                                controller: TextEditingController(
                                  text: controller.deliveryDetails?.mobile ?? na,
                                ),
                              ),
                              if (controller.selectedBranch?.isDelivery == true) ...[
                                const SizedBox(height: 16),
                                CTextField(
                                  maxLines: 3,
                                  minLines: null,
                                  validator: AppValidator.emptyNullValidator,
                                  controller: controller.deliveryAddressController,
                                  labelText: TranslationController.td.deliveryAddress,
                                ),
                              ] else ...[
                                const SizedBox(height: 16),
                                CTextField(
                                  maxLines: 3,
                                  minLines: null,
                                  enabled: false,
                                  labelText: TranslationController.td.branchAddress,
                                  controller: TextEditingController(
                                    text: controller.selectedBranch?.branchAddress ?? na,
                                  ),
                                ),
                              ],
                            ],
                            const SizedBox(height: 16),
                          ],
                          if (controller.currentStep == 2) ...[
                            CCoreButton(
                              onPressed: controller.gotoStep1,
                              child: Row(
                                children: [
                                  selectIcon(
                                    AppIcons.arrowLeftiOS,
                                    width: 12,
                                    color: getPrimaryColor,
                                  ),
                                  const SizedBox(width: 10),
                                  CText(
                                    TranslationController.td.previousStep,
                                    style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const _ItemListView(),
                          ],
                        ],
                      ).defaultHorizontal,
                    ),
                  ),
          ),
          bottomNavigationBar: controller.isLoading
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.currentStep == 1)
                      CFlatButton(
                        bgColor: getBg1,
                        textColor: getPrimaryColor,
                        onPressed: controller.gotoStep2,
                        text: TranslationController.td.next,
                        border: Border.all(color: getPrimaryColor),
                      ),
                    if (controller.currentStep == 2) ...[
                      CText(
                        "${TranslationController.td.totalSelectedGoldWeight}: ${attachUnit(controller.calculateSelectedGoldWeight())}",
                        style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                      ),
                      const SizedBox(height: 10),
                      CFlatButton(
                        onPressed: controller.onPlaceOrder,
                        text: TranslationController.td.placeOrder,
                        isDisabled: controller.calculateSelectedGoldWeight() <= 0,
                      ),
                    ],
                  ],
                ).bottomNavBarButton(context),
        );
      },
    );
  }
}

class _ItemListView extends StatelessWidget {
  const _ItemListView();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldWithdrawalController>(
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          physics: neverScrollablePhysics,
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            int qty = controller.items[index].qty;
            GetGoldPhysicalWithdrawalItemModel item = controller.items[index].item;
            bool isStockAvailable = !(item.stockBalance <= 0.0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  item.itemCode ?? na,
                  style: TextThemeX.text16.copyWith(
                    color: getColorWhiteBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Html(
                  data: """${item.description}""",
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      color: getdarkGColor,
                      fontSize: FontSize(16),
                      padding: HtmlPaddings.zero,
                      fontWeight: FontWeight.w500,
                    ),
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    networkImage(imageUrl: item.image, width: 70, borderRadius: 8),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${TranslationController.td.goldWeight}: ",
                                  style: TextThemeX.text14,
                                ),
                                TextSpan(
                                  text: attachUnit(item.goldWeight ?? na),
                                  style: TextThemeX.text14.copyWith(
                                    color: getColorWhiteBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (!isStockAvailable)
                            CFlatButton(
                              width: 100,
                              height: 36,
                              fontSize: 14,
                              borderRadius: 8,
                              onPressed: () {},
                              textColor: lightRed,
                              bgColor: lightRed.withOpacity(0.1),
                              border: Border.all(color: lightRed),
                              text: TranslationController.td.outOfStock,
                            ),
                          if (isStockAvailable)
                            qty <= 0
                                ? CFlatButton(
                                    onPressed: () {
                                      controller.onQtyIncreased(controller.items[index]);
                                    },
                                    width: 100,
                                    height: 36,
                                    fontSize: 14,
                                    borderRadius: 8,
                                    text: TranslationController.td.addToCart,
                                  )
                                : Row(
                                    children: [
                                      CCoreButton(
                                        onPressed: () =>
                                            controller.onQtyDecreased(controller.items[index]),
                                        child: Icon(
                                          CupertinoIcons.minus_circle_fill,
                                          size: 26,
                                          color: getdarkGColor,
                                        ),
                                      ),
                                      CText(
                                        '$qty',
                                        style: TextThemeX.text16.copyWith(
                                          color: getColorWhiteBlack,
                                        ),
                                      ).paddingSymmetric(horizontal: 10),
                                      CCoreButton(
                                        onPressed: () =>
                                            controller.onQtyIncreased(controller.items[index]),
                                        child:
                                            const Icon(CupertinoIcons.plus_circle_fill, size: 26),
                                      ),
                                    ],
                                  ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ).defaultContainer(hM: 0, vP: 10, hP: 16).paddingOnly(bottom: 12);
          },
        );
      },
    );
  }
}

class _FormStepNavigator extends StatelessWidget {
  const _FormStepNavigator();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldWithdrawalController>(
      builder: (controller) {
        return SizedBox(
          height: 30,
          width: 50 * controller.totalSteps.toDouble(),
          child: ListView.builder(
            physics: neverScrollablePhysics,
            scrollDirection: Axis.horizontal,
            itemCount: controller.totalSteps,
            itemBuilder: (context, index) {
              bool isLastStep = index == controller.totalSteps - 1;
              return Row(
                children: [
                  AnimatedContainer(
                    width: 28,
                    height: 28,
                    duration: 300.ms,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < controller.currentStep ? getPrimaryColor : getOutlineColor,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                    ),
                  ),
                  if (!isLastStep)
                    AnimatedContainer(
                      width: 26,
                      height: 2,
                      duration: 300.ms,
                      color: index < controller.currentStep - 1 ? getPrimaryColor : getOutlineColor,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
