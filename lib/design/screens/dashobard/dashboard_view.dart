import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/dashboard_controller.dart';
import '/design/screens/dashobard/tabs/history/history_tab.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/design/screens/dashobard/tabs/home/home_tab.dart';
import '/design/screens/dashobard/tabs/profile/profile_view.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_tab.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(
            leadingWidth: 180,
            leading: selectImage(
              AppImages.logo2,
            ).paddingOnly(left: horizontalPadding),
            actions: [
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Badge(
                    backgroundColor: lightRed,
                    smallSize: switch (controller.dashboardDetails?.openNotificationLog) {
                      false => 0,
                      _ => 7
                    },
                    child: selectIcon(
                      AppIcons.bell,
                      onPressed: () {
                        Get.toNamed(Routes.NOTIFICATIONS);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 15),
              MenuAnchor(
                alignmentOffset: const Offset(0, 20),
                style: MenuStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                menuChildren: [
                  CCoreButton(
                    color: pullDownMenuBgColor,
                    borderRadius: BorderRadius.zero,
                    onPressed: !controller.isHomeControllerInitialized
                        ? null
                        : () async {
                            await showAdaptiveDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: getDialogBarrierColor,
                              builder: (context) {
                                return const _ReferralQrCode();
                              },
                            );
                          },
                    child: Row(
                      children: [
                        selectIcon(AppIcons.qr, color: getColorWhiteBlack, width: 24),
                        const SizedBox(width: 8),
                        CText(
                          "My QR",
                          style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                        ),
                      ],
                    ).paddingAll(15),
                  ),
                  CCoreButton(
                    color: pullDownMenuBgColor,
                    borderRadius: BorderRadius.zero,
                    onPressed: () => Get.toNamed(Routes.NETWORK),
                    child: Row(
                      children: [
                        selectIcon(AppIcons.network, color: getColorWhiteBlack),
                        const SizedBox(width: 8),
                        CText(
                          "My Network",
                          style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                        ),
                      ],
                    ).paddingAll(15),
                  ),
                  CCoreButton(
                    onPressed: controller.logout,
                    borderRadius: BorderRadius.zero,
                    child: Row(
                      children: [
                        selectIcon(AppIcons.logout),
                        const SizedBox(width: 8),
                        CText(
                          TranslationController.td.logout,
                          style: TextThemeX.text14.copyWith(color: lightRed),
                        ),
                      ],
                    ).paddingAll(15),
                  ),
                ],
              ),
              const SizedBox(width: horizontalPadding),
            ],
          ),
          body: PersistentTabView.custom(
            context,
            backgroundColor: getBg2,
            controller: controller.tabController,
            screens: const [
              HomeTab(),
              WalletTab(),
              HistoryTab(),
              ProfileView(),
            ],
            itemCount: 4,
            onWillPop: (context) async {
              return true;
            },
            resizeToAvoidBottomInset: true,
            customWidget: Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: getOutlineColor))),
              child: CBottomBar(
                backgroundColor: getBg2,
                activeColor: getLightGold,
                onTap: controller.onTabChanged,
                currentIndex: controller.tabController.index,
                border: const Border.symmetric(vertical: BorderSide.none),
                items: [
                  BottomNavigationBarItem(
                    icon: selectIcon(AppIcons.home),
                    label: TranslationController.td.home,
                    activeIcon: selectIcon(AppIcons.home, color: getPrimaryColor),
                  ),
                  BottomNavigationBarItem(
                    label: TranslationController.td.wallet,
                    activeIcon: selectIcon(AppIcons.wallet, color: getPrimaryColor),
                  ),
                  BottomNavigationBarItem(
                    icon: selectIcon(AppIcons.history),
                    label: TranslationController.td.history,
                    activeIcon: selectIcon(AppIcons.history, color: getPrimaryColor),
                  ),
                  BottomNavigationBarItem(
                    label: TranslationController.td.profile,
                    icon: CircleAvatar(
                      radius: 12,
                      backgroundColor: getColorBlackWhite,
                      backgroundImage: selectAPIImageProvider(
                        imageUrl: controller.profile?.profilePhoto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
              ? null
              : FloatingActionButton(
                  heroTag: null,
                  shape: const CircleBorder(),
                  onPressed: () async {
                    await requestCameraPermission();
                    Get.toNamed(Routes.SCAN_QR);
                  },
                  child:
                      Icon(CupertinoIcons.qrcode_viewfinder, size: 34, color: getColorWhiteBlack),
                ).paddingOnly(bottom: 30),
        );
      },
    );
  }
}

class _ReferralQrCode extends StatelessWidget {
  const _ReferralQrCode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        String? referralCode;
        String? referralLink;
        try {
          if (controller.isHomeControllerInitialized) {
            referralLink = Get.find<HomeController>().dashboardDetails?.referralLink ?? "";
            referralCode = Uri.tryParse(referralLink)?.queryParameters['sponser'];
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  decoration: BoxDecoration(
                    color: getBg2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CText(
                        'Your Referral Code',
                        style: TextThemeX.text12.copyWith(
                          color: getLightGold,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CCoreButton(
                        onPressed: () {
                          DesignUtils.copyToClipboard(referralCode);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CText(
                              '$referralCode',
                              style: TextThemeX.text14.copyWith(color: getPrimaryTextColor),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.copy_outlined, size: 16, color: getPrimaryTextColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      CText(
                        'Your Referral Link',
                        style: TextThemeX.text12.copyWith(
                          color: getLightGold,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CCoreButton(
                        onPressed: () {
                          DesignUtils.copyToClipboard(referralLink);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$referralLink',
                                style: TextThemeX.text14.copyWith(
                                  height: 1.3,
                                  color: getPrimaryTextColor,
                                ),
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.copy_outlined,
                                  size: 16,
                                  color: getPrimaryTextColor,
                                ).paddingOnly(left: 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      QrImageView(
                        size: 185,
                        data: "$referralLink",
                        dataModuleStyle: QrDataModuleStyle(
                          color: getColorWhiteBlack,
                          dataModuleShape: QrDataModuleShape.square,
                        ),
                        eyeStyle: QrEyeStyle(
                          color: getColorWhiteBlack,
                          eyeShape: QrEyeShape.square,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CText(
                        'Your friend can scan this QR to join QM or add your referral code on Register page on QM app or you can register him/her using below button.',
                        textAlign: TextAlign.center,
                        style: TextThemeX.text14.copyWith(
                          fontSize: 15,
                          color: getGrey1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CFlatButton(
                        borderRadius: 8,
                        bgColor: getBg2,
                        textColor: getPrimaryColor,
                        border: Border.all(color: getPrimaryColor),
                        onPressed: () {
                          if (!isNullEmptyOrFalse(referralLink)) {
                            Get
                              ..back()
                              ..toNamed(Routes.REGISTER_MEMBER(referrer: referralCode));
                          }
                        },
                        text: TranslationController.td.registerUser,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -35,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: getColorBlackWhite,
                    backgroundImage:
                        selectAPIImageProvider(imageUrl: controller.profile?.profilePhoto),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 35,
                  child: selectIcon(
                    AppIcons.close,
                    width: 30,
                    onPressed: Get.back,
                    color: getColorWhiteBlack,
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
