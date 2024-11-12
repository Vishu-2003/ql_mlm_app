import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '/core/routes/app_pages.dart';
import '/core/services/gs_services.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? defaultLoader()
              : RefreshIndicator.adaptive(
                  onRefresh: controller.init,
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: getColorBlackWhite,
                              backgroundImage: selectAPIImageProvider(
                                imageUrl: controller.profileDetails?.profilePhoto,
                              ),
                            ),
                            Positioned(
                              bottom: -15,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  selectIcon(
                                    AppIcons.badge,
                                    color: controller.badgeTheme?.badgeColor ?? getPrimaryTextColor,
                                  ),
                                  const SizedBox(width: 4),
                                  CText(
                                    controller.profileDetails?.currentBadge ?? na,
                                    style: TextThemeX.text14.copyWith(
                                      color: getColorWhiteBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ).defaultContainer(borderRadius: 40, hP: 16, vP: 6),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CText(
                          controller.profileDetails?.memberName ?? na,
                          style: TextThemeX.text16.copyWith(
                            color: getColorWhiteBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CText(
                          controller.profileDetails?.mobile ?? na,
                          style: TextThemeX.text14.copyWith(
                            color: getColorWhiteBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CText(controller.profileDetails?.email ?? na, style: TextThemeX.text14),
                        const SizedBox(height: 16),
                        CFlatButton(
                          onPressed: () {
                            Get.toNamed(Routes.EDIT_PROFILE)?.then((value) {
                              if (value == true) controller.init();
                            });
                          },
                          textColor: getPrimaryColor,
                          bgColor: Colors.transparent,
                          text: TranslationController.td.editProfile,
                          border: Border.all(color: getPrimaryColor),
                        ).defaultHorizontal,
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                CText(TranslationController.td.currency, style: TextThemeX.text12),
                                const SizedBox(height: 4),
                                CText(
                                  controller.profileDetails?.currency ?? na,
                                  style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CText(TranslationController.td.accountType,
                                    style: TextThemeX.text12),
                                const SizedBox(height: 4),
                                CText(
                                  controller.profileDetails?.accountType ?? na,
                                  style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CText(TranslationController.td.sponsor, style: TextThemeX.text12),
                                const SizedBox(height: 4),
                                CText(
                                  controller.profileDetails?.sponserName ?? na,
                                  style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                ),
                              ],
                            ),
                          ],
                        ).defaultContainer(hM: 0),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(
                                    TranslationController.td.dateOfBirth,
                                    style: TextThemeX.text12,
                                  ),
                                  const SizedBox(height: 4),
                                  CText(
                                    controller.profileDetails?.dateOfBirth ?? na,
                                    style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(TranslationController.td.address, style: TextThemeX.text12),
                                  const SizedBox(height: 4),
                                  CText(
                                    "${controller.profileDetails?.addressLine1 ?? na}, ${controller.profileDetails?.addressLine2 ?? na}",
                                    overflow: TextOverflow.visible,
                                    style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            selectIcon(
                              switch (controller.biometricType) {
                                BiometricType.face => AppIcons.face2,
                                BiometricType.fingerprint => AppIcons.fingerPrint,
                                _ => AppIcons.lock,
                              },
                              width: 22,
                              color: GSServices.getBiometricAuth ? getPrimaryColor : null,
                            ),
                            const SizedBox(width: 10),
                            CText(
                              switch (controller.biometricType) {
                                BiometricType.face => TranslationController.td.enableFaceID,
                                BiometricType.fingerprint =>
                                  TranslationController.td.enableFingerprint,
                                _ => TranslationController.td.enableLockScreen,
                              },
                              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                            ),
                            const Spacer(),
                            Transform.scale(
                              scale: .8,
                              child: Switch.adaptive(
                                activeColor: getPrimaryColor,
                                value: GSServices.getBiometricAuth,
                                onChanged: controller.toogleBiometric,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: getOutlineColor, height: 15),
                        const SizedBox(height: 10),
                        _FeatureRow(
                          icon: AppIcons.lock,
                          text: TranslationController.td.changePassword,
                          onPressed: () {
                            Get.toNamed(Routes.CHANGE_PASSWORD);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.bank,
                          text: TranslationController.td.connectedBankAccount,
                          onPressed: () {
                            Get.toNamed(Routes.BANK_DETAILS);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.receiveSquare,
                          onPressed: () {
                            Get.toNamed(Routes.GOLD_WITHDRAWAL_REQUESTS);
                          },
                          text: TranslationController.td.goldWithdrawalRequest,
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.user2,
                          onPressed: () {
                            Get.toNamed(Routes.RECIPIENT);
                          },
                          text: TranslationController.td.manageRecipient,
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.user2,
                          text: "Beneficiary Designation",
                          onPressed: () {
                            Get.toNamed(Routes.BENEFICIARY_DESIGNATION);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.wallet2,
                          text: TranslationController.td.walletHistory,
                          onPressed: () {
                            Get.toNamed(Routes.WALLET_HISTORY());
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.percentageCircle,
                          text: TranslationController.td.commissionHistory,
                          onPressed: () {
                            Get.toNamed(Routes.COMMISSION_HISTORY);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.twoUsers,
                          text: TranslationController.td.myReferral,
                          onPressed: () {
                            Get.toNamed(Routes.REFERRER_HISTORY);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.faq,
                          text: TranslationController.td.fAQ,
                          onPressed: () {
                            Get.toNamed(Routes.FAQ);
                          },
                        ),
                        _divider(),
                        _FeatureRow(
                          icon: AppIcons.headphone,
                          text: TranslationController.td.helpDesk,
                          onPressed: () {
                            Get.toNamed(Routes.TICKETS);
                          },
                        ),
                        _divider(),
                        _CloseAccount(),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CText(
                            'v${controller.appVersion}',
                            style: TextThemeX.text12.copyWith(color: getPrimaryColor),
                          ),
                        ),
                        SizedBox(height: context.bottomPadding + 50),
                      ],
                    ),
                  ).defaultHorizontal,
                ),
        );
      },
    );
  }

  Divider _divider() => Divider(color: getOutlineColor, height: 40);
}

class _FeatureRow extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String text;
  const _FeatureRow({Key? key, required this.onPressed, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCoreButton(
      onPressed: onPressed,
      child: Row(
        children: [
          selectIcon(icon, width: 23),
          const SizedBox(width: 10),
          Expanded(
            child: CText(
              text,
              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
            ),
          ),
          selectIcon(AppIcons.arrowRight),
        ],
      ),
    );
  }
}

class _CloseAccount extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return CCoreButton(
      onPressed: controller.closeAccount,
      child: Row(
        children: [
          selectIcon(AppIcons.close2, width: 23),
          const SizedBox(width: 10),
          Expanded(
            child: CText(
              TranslationController.td.closeAccount,
              style: TextThemeX.text14.copyWith(color: lightRed),
            ),
          ),
        ],
      ),
    );
  }
}
