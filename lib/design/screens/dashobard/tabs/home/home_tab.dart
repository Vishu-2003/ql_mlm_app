import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/dashboard_controller.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
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
                          const SizedBox(height: 1),
                          const _OpeningClosingTime(),
                          const SizedBox(height: 1),
                          const GoldPrice(),
                          const SizedBox(height: 16),
                          _QuickShortcuts(),
                          const SizedBox(height: 16),
                          if (controller.dashboardDetails?.kycStatus != 'Verified') ...[
                            const _KYCVerification(),
                            const SizedBox(height: 16),
                          ],
                          const _QuickDetailsCardGrid(),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CText(
                              "Gold Items",
                              style: TextThemeX.text18.copyWith(
                                color: getColorWhiteBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ).defaultHorizontal,
                          const SizedBox(height: 8),
                          const _GoldCardListView(),
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

class _QuickShortcuts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getBg1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getOutlineColor, width: 1),
      ),
      child: Column(
        children: [
          CCoreButton(
            onPressed: () {
              Get.find<DashboardController>().navigateToHistory(
                HistoryType.qmGoldAutoTradeHistory,
              );
            },
            child: Row(
              children: [
                selectIcon(AppIcons.history2),
                const SizedBox(width: 8),
                Expanded(
                  child: CText(
                    "QM Gold Auto Trade History",
                    style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                  ),
                ),
                selectIcon(AppIcons.arrowRight),
              ],
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: 10),
          ),
          Divider(color: getOutlineColor, height: 0),
          CCoreButton(
            onPressed: () {
              Get.find<DashboardController>().navigateToHistory(
                HistoryType.gaexAutoTradeHistory,
              );
            },
            child: Row(
              children: [
                selectIcon(AppIcons.history2),
                const SizedBox(width: 8),
                Expanded(
                  child: CText(
                    "GAEX Auto Trade History",
                    style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                  ),
                ),
                selectIcon(AppIcons.arrowRight),
              ],
            ).paddingSymmetric(horizontal: horizontalPadding, vertical: 10),
          ),
        ],
      ),
    ).defaultHorizontal;
  }
}

class _KYCVerification extends StatelessWidget {
  const _KYCVerification();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final String? kycStatus = controller.dashboardDetails?.kycStatus;
        final bool isPending = kycStatus == "Pending";
        final bool isFailed = kycStatus == "Failed";
        final bool isUnderReview = kycStatus == "Under Review";
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    isPending
                        ? TranslationController.td.kYCVerificationIsPending
                        : isUnderReview
                            ? TranslationController.td.kYCVerificationIsUnderReview
                            : isFailed
                                ? TranslationController.td.kYCVerificationFailed
                                : "",
                    style: TextThemeX.text14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUnderReview
                          ? blue
                          : isFailed
                              ? lightRed
                              : getdarkGColor,
                    ),
                  ),
                  if (isFailed && !isNullEmptyOrFalse(controller.dashboardDetails?.kycMessage))
                    CText(
                      controller.dashboardDetails?.kycMessage ?? na,
                      style: TextThemeX.text14.copyWith(
                        color: getLightGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (isPending || isFailed)
              CFlatButton(
                width: 100,
                onPressed: controller.onStartKYC,
                text:
                    isPending ? TranslationController.td.verify : TranslationController.td.reVerify,
              )
          ],
        ).defaultHorizontal;
      },
    );
  }
}

class _OpeningClosingTime extends GetWidget<HomeController> {
  const _OpeningClosingTime();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: getBg1,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Marquee(
        velocity: 20,
        textScaleFactor: 1,
        blankSpace: horizontalPadding,
        startPadding: horizontalPadding,
        text: controller.dashboardDetails?.marketTime ?? "-",
        style: TextThemeX.text12.copyWith(color: getdarkGColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class GoldPrice extends GetWidget<HomeController> {
  const GoldPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: getBg1,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          CText(
            "${TranslationController.td.lbmagoldPrice}: ${controller.dashboardDetails?.goldPriceUsd}  |  ${controller.dashboardDetails?.goldPrice}",
            style: TextThemeX.text12.copyWith(color: getPrimaryColor, fontWeight: FontWeight.w600),
          ),
          CText(
            "${TranslationController.td.exchangeRate}: ${controller.dashboardDetails?.exchangeRate ?? na}",
            style: TextThemeX.text12.copyWith(color: getPrimaryColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _GoldCardListView extends GetWidget<HomeController> {
  const _GoldCardListView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.items.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 360,
            child: CCoreButton(
              onPressed: () {
                Get.toNamed(Routes.ITEM_DETAILS, arguments: controller.items[index].toJson())
                    ?.then((value) {
                  controller.getDashboardDetails();
                });
              },
              child: Row(
                children: [
                  networkImage(
                    width: 48,
                    borderRadius: 8,
                    imageUrl: controller.items[index].image,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          controller.items[index].itemName ?? na,
                          style: TextThemeX.text16.copyWith(
                            color: getColorWhiteBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        detailsRow(
                          controller.items[index].itemType == "Contract"
                              ? "${TranslationController.td.unitPrice}:"
                              : "${TranslationController.td.minimumPrice}:",
                          controller.items[index].unitPrice ?? na,
                          value2: controller.items[index].baseUnitPrice ?? na,
                        ),
                        const SizedBox(height: 5),
                        detailsRow(
                          "${TranslationController.td.goldRate}(${TranslationController.td.g}):",
                          controller.items[index].goldPrice ?? na,
                          value2: controller.items[index].baseGoldPrice ?? na,
                        ),
                        const SizedBox(height: 5),
                        detailsRow(
                          "${TranslationController.td.estimatedGold}:",
                          attachUnit(controller.items[index].estimatedGold),
                        ),
                      ],
                    ),
                  ),
                ],
              ).defaultContainer(hM: 8),
            ),
          );
        },
      ),
    );
  }

  Row detailsRow(String title, String value, {String? value2}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CText(
            title,
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

class _QuickDetailsCardGrid extends StatelessWidget {
  const _QuickDetailsCardGrid();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return AlignedGridView.custom(
          itemCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 170,
          ),
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return _QuickDetailsCard(
                  icon: AppIcons.user,
                  onPressed: () {
                    Get.toNamed(Routes.NETWORK);
                  },
                  title: TranslationController.td.totalIntroducers,
                  value: "${controller.dashboardDetails?.totalIntroducter ?? na}",
                );
              case 1:
                return _QuickDetailsCard(
                  icon: AppIcons.graph,
                  title: TranslationController.td.personalTrade,
                  onPressed: () {
                    Get.find<DashboardController>().navigateToHistory(
                      HistoryType.gaeHistory,
                    );
                  },
                  value: controller.dashboardDetails?.totalPersonalTrade ?? na,
                  value2: controller.dashboardDetails?.baseTotalPersonalTrade ?? na,
                );
              case 2:
                return _QuickDetailsCard(
                  icon: AppIcons.graph,
                  title: TranslationController.td.memberTrade,
                  onPressed: () {
                    Get.find<DashboardController>().navigateToHistory(
                      HistoryType.memberGaeHistory,
                    );
                  },
                  value: controller.dashboardDetails?.totalMemberTrade ?? na,
                  value2: controller.dashboardDetails?.baseTotalMemberTrade ?? na,
                );
              case 3:
                return _QuickDetailsCard(
                  icon: AppIcons.moneyBag,
                  onPressed: () {
                    Get.toNamed(Routes.COMMISSION_HISTORY);
                  },
                  title: TranslationController.td.totalCommissions,
                  value: controller.dashboardDetails?.totalCommission ?? na,
                  value2: controller.dashboardDetails?.baseTotalCommission ?? na,
                );
              case 4:
                return _QuickDetailsCard(
                  icon: AppIcons.moneyBag,
                  title: TranslationController.td.totalDeposits,
                  value: controller.dashboardDetails?.totalDeposits ?? na,
                  value2: controller.dashboardDetails?.baseTotalDeposits ?? na,
                  onPressed: () {
                    Get.find<DashboardController>().navigateToHistory(
                      HistoryType.depositHistory,
                    );
                  },
                );
              case 5:
              default:
                return _QuickDetailsCard(
                  icon: AppIcons.moneyBag,
                  title: TranslationController.td.totalWithdrawals,
                  value: controller.dashboardDetails?.totalWithdrawals ?? na,
                  value2: controller.dashboardDetails?.baseTotalWithdrawals ?? na,
                  onPressed: () {
                    Get.find<DashboardController>().navigateToHistory(
                      HistoryType.withdrawalHistory,
                    );
                  },
                );
            }
          },
        );
      },
    );
  }
}

class _QuickDetailsCard extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final String? value2;
  final VoidCallback? onPressed;

  const _QuickDetailsCard({
    this.value2,
    this.onPressed,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: selectIcon(icon)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              value,
              maxLines: 1,
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextThemeX.text16.copyWith(
                color: getPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (value2 != null)
            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                value2 ?? '',
                maxLines: 1,
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: TextThemeX.text12.copyWith(
                  color: getColorWhiteBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              title,
              maxLines: 1,
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: TextThemeX.text14.copyWith(color: getPrimaryTextColor),
            ),
          ),
        ],
      ).defaultContainer(hM: 0),
    );
  }
}
