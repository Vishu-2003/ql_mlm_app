import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/dashboard_controller.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? defaultLoader()
              : RefreshIndicator.adaptive(
                  onRefresh: controller.init,
                  child: SizedBox.expand(
                    child: SingleChildScrollView(
                      physics: defaultScrollablePhysics,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const _GoldStorageAccount(),
                          const SizedBox(height: 16),
                          const _GoldConvertAccount(),
                          const SizedBox(height: 16),
                          const _CashAccount(),
                          const SizedBox(height: 16),
                          _PayoutSettings(),
                          SizedBox(height: context.bottomPadding + 50),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _PayoutSettings extends GetWidget<WalletController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CText(
                TranslationController.td.commissionPayoutSetting.toUpperCase(),
                style: TextThemeX.text14
                    .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
              ),
            ),
            _DefaultMenuAnchor(
              menuChildren: [
                _MenuAnchorItem(
                  isLast: true,
                  isFirst: true,
                  title: TranslationController.td.commissionHistory,
                  onTap: () {
                    Get.toNamed(Routes.COMMISSION_HISTORY);
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < (controller.walletDetails?.payoutSettings?.length ?? 0); i++)
          GetBuilder<WalletController>(
            id: i,
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CText(
                      controller.walletDetails?.payoutSettings?[i].payoutSettings ?? na,
                      style: TextThemeX.text14.copyWith(color: getGrey1),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 100,
                    child: CTextField(
                      suffixText: "%",
                      inputFormatters: [CTextField.decimalFormatter],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController(
                        text:
                            "${controller.walletDetails?.payoutSettings?[i].percentage?.toStringAsFixed(2)}",
                      ),
                      onChanged: (value) {
                        try {
                          controller.walletDetails?.payoutSettings?[i].percentage =
                              double.parse(value);
                          if (controller.walletDetails?.payoutSettings?.length == 2) {
                            controller.walletDetails?.payoutSettings?[i == 0 ? 1 : 0].percentage =
                                100.0 -
                                    (controller.walletDetails?.payoutSettings?[i].percentage ?? 0);
                            controller.update([i == 0 ? 1 : 0]);
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  ),
                ],
              ).paddingOnly(bottom: 16);
            },
          ),
        CFlatButton(
          bgColor: getBg1,
          textColor: getPrimaryColor,
          isDisabled: !controller.isKYCVerified,
          text: TranslationController.td.update,
          border: Border.all(color: getPrimaryColor),
          onPressed: controller.onPayoutSettingsUpdated,
        ),
      ],
    ).defaultContainer(hP: 16, vP: 16);
  }
}

class _CashAccount extends StatelessWidget {
  const _CashAccount();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CText(
                    TranslationController.td.floatAccount.toUpperCase(),
                    style: TextThemeX.text14
                        .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                  ),
                ),
                _DefaultMenuAnchor(
                  menuChildren: [
                    _MenuAnchorItem(
                      title: TranslationController.td.depositHistory,
                      isFirst: true,
                      onTap: () {
                        Get.find<DashboardController>().navigateToHistory(
                          HistoryType.depositHistory,
                        );
                      },
                    ),
                    _MenuAnchorItem(
                      title: TranslationController.td.withdrawalHistory,
                      onTap: () {
                        Get.find<DashboardController>().navigateToHistory(
                          HistoryType.withdrawalHistory,
                        );
                      },
                    ),
                    _MenuAnchorItem(
                      title: TranslationController.td.walletHistory,
                      isLast: true,
                      onTap: () {
                        Get.toNamed(Routes.WALLET_HISTORY());
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TitleValueRow(
              TranslationController.td.cashBalanceInCurrency,
              controller.walletDetails?.qmCashWallet?.cashBalanceInCurrency ?? na,
              value2: controller.walletDetails?.qmCashWallet?.baseCashBalanceInCurrency ?? na,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CFlatButton(
                    bgColor: green,
                    isDisabled: !controller.isKYCVerified,
                    text: TranslationController.td.deposit,
                    onPressed: () {
                      Get.toNamed(Routes.DEPOSIT_FUND())?.then((value) {
                        if (value == true) controller.init();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CFlatButton(
                    bgColor: lightRed,
                    isDisabled: !controller.isKYCVerified,
                    text: TranslationController.td.withdrawal,
                    onPressed: () {
                      Get.toNamed(Routes.WITHDRAW_FUND)?.then((value) {
                        if (value == true) controller.init();
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ).defaultContainer(hP: 16, vP: 16);
      },
    );
  }
}

class _GoldConvertAccount extends StatelessWidget {
  const _GoldConvertAccount();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              "${TranslationController.td.goldConvertAccount.toUpperCase()} (${TranslationController.td.gca.toUpperCase()})",
              style: TextThemeX.text14
                  .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TitleValueRow(
              TranslationController.td.availableGoldConvert,
              attachUnit(controller.walletDetails?.qmGcaWallet?.availableGoldWeight),
            ),
            const SizedBox(height: 16),
            TitleValueRow(
              TranslationController.td.availableGoldConvertValue,
              controller.walletDetails?.qmGcaWallet?.availableGoldInCurrency ?? na,
              value2: controller.walletDetails?.qmGcaWallet?.baseAvailableGoldInCurrency ?? na,
            ),
            const SizedBox(height: 16),
            CFlatButton(
              bgColor: getBg1,
              textColor: getPrimaryColor,
              isDisabled: !controller.isKYCVerified,
              text: TranslationController.td.goldConvert,
              border: Border.all(color: getPrimaryColor),
              onPressed: () {
                Get.toNamed(Routes.CONVERT_GOLD)?.then((value) {
                  if (value == true) controller.init();
                });
              },
            ),
            const SizedBox(height: 12),
            CFlatButton(
              bgColor: getBg1,
              textColor: getPrimaryColor,
              isDisabled: !controller.isKYCVerified,
              border: Border.all(color: getPrimaryColor),
              text: TranslationController.td.goldConvertRepayment,
              onPressed: () {
                Get.toNamed(
                  Routes.CONVERT_GOLD_REPAYMENT,
                )?.then((value) => controller.getWalletDetails());
              },
            ),
          ],
        ).defaultContainer(hP: 16, vP: 16);
      },
    );
  }
}

class TitleValueRow extends StatelessWidget {
  final String title;
  final String value;
  final String? value2;

  const TitleValueRow(this.title, this.value, {super.key, this.value2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CText(
            title,
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CText(
              value,
              style: TextThemeX.text14.copyWith(
                color: getPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (value2 != null)
              CText(
                value2!,
                style: TextThemeX.text12.copyWith(color: getColorWhiteBlack),
              ),
          ],
        ),
      ],
    );
  }
}

class _GoldStorageAccount extends StatelessWidget {
  const _GoldStorageAccount();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CText(
                    "${TranslationController.td.goldStorageAccount.toUpperCase()} (${TranslationController.td.gsa.toUpperCase()})",
                    style: TextThemeX.text14
                        .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                  ),
                ),
                _DefaultMenuAnchor(
                  menuChildren: [
                    _MenuAnchorItem(
                      title: TranslationController.td.gsaHistory,
                      isFirst: true,
                      onTap: () {
                        Get.find<DashboardController>().navigateToHistory(
                          HistoryType.gsaHistory,
                        );
                      },
                    ),
                    _MenuAnchorItem(
                      title: TranslationController.td.gaeHistory,
                      isLast: true,
                      onTap: () {
                        Get.find<DashboardController>().navigateToHistory(
                          HistoryType.gaeHistory,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TitleValueRow(
              TranslationController.td.goldHolding,
              attachUnit(controller.walletDetails?.qmGsaWallet?.holdingWeight),
            ),
            const SizedBox(height: 16),
            TitleValueRow(
              "${TranslationController.td.currentValue}\n(${TranslationController.td.baseOnGoldSpotPrice})",
              controller.walletDetails?.qmGsaWallet?.holdingValueInCurrency ?? na,
              value2: controller.walletDetails?.qmGsaWallet?.baseHoldingValueInCurrency ?? na,
            ),
            const SizedBox(height: 16),
            CFlatButton(
              bgColor: getBg1,
              textColor: getPrimaryColor,
              isDisabled: !controller.isKYCVerified,
              border: Border.all(color: getPrimaryColor),
              text: TranslationController.td.physicalGoldWithdrawal,
              onPressed: () {
                Get.toNamed(Routes.GOLD_PHYSICAL_WITHDRAWAL)?.then((value) {
                  if (value == true) controller.init();
                });
              },
            ),
            const SizedBox(height: 12),
            CFlatButton(
              bgColor: getBg1,
              textColor: getPrimaryColor,
              isDisabled: !controller.isKYCVerified,
              border: Border.all(color: getPrimaryColor),
              text: TranslationController.td.goldTransfer,
              onPressed: () {
                Get.toNamed(Routes.GOLD_TRANSFER)?.then((value) {
                  if (value == true) controller.init();
                });
              },
            ),
          ],
        ).defaultContainer(hP: 16, vP: 16);
      },
    );
  }
}

class _DefaultMenuAnchor extends StatelessWidget {
  final List<Widget> menuChildren;
  const _DefaultMenuAnchor({required this.menuChildren});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 5),
      style: MenuStyle(
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(const EdgeInsets.only(right: 30)),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return CCoreButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Icon(Icons.more_vert, color: getColorWhiteBlack),
        );
      },
      menuChildren: menuChildren,
    );
  }
}

class _MenuAnchorItem extends StatelessWidget {
  final bool isLast;
  final String title;
  final bool isFirst;
  final VoidCallback? onTap;
  const _MenuAnchorItem({
    required this.title,
    this.onTap,
    this.isLast = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CCoreButton(
        color: pullDownMenuBgColor,
        child: Container(
          decoration: BoxDecoration(
            color: pullDownMenuBgColor,
            borderRadius: switch ((isFirst, isLast)) {
              (false, false) => BorderRadius.zero,
              (true, true) => BorderRadius.circular(16),
              (true, false) => const BorderRadius.vertical(top: Radius.circular(16)),
              (false, true) => const BorderRadius.vertical(bottom: Radius.circular(16)),
            },
          ),
          child: Row(
            children: [
              selectIcon(AppIcons.history2),
              const SizedBox(width: 8),
              CText(
                title,
                style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
              ),
            ],
          ).paddingAll(15),
        ),
      ),
    );
  }
}
