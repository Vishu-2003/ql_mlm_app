import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/register_member_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class RegisterMemberView extends StatelessWidget {
  const RegisterMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterMemberController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.registerANewMember),
          body: controller.isLoading
              ? defaultLoader()
              : Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        if (Get.previousRoute == Routes.LOGIN) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (Platform.isIOS) ...[
                                selectIcon(
                                  AppIcons.apple,
                                  width: 28,
                                  onPressed: controller.onAppleSignIn,
                                ),
                                const SizedBox(width: 20),
                              ],
                              selectIcon(
                                AppIcons.google,
                                width: 26,
                                onPressed: controller.onGoogleSignUp,
                              ),
                              const SizedBox(width: 20),
                              selectIcon(
                                AppIcons.twitter,
                                width: 24,
                                onPressed: controller.onXSignIn,
                              ),
                              const SizedBox(width: 20),
                              selectIcon(
                                AppIcons.facebook,
                                width: 28,
                                onPressed: controller.onFacebookSignUp,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                        CTextField(
                          keyboardType: TextInputType.text,
                          validator: AppValidator.emptyNullValidator,
                          controller: controller.referralNameOrCodeController,
                          labelText: TranslationController.td.referralNameOrCode,
                        ),
                        const SizedBox(height: 24),
                        CTextField(
                          controller: controller.emailController,
                          validator: AppValidator.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          labelText: TranslationController.td.email,
                        ),
                        const SizedBox(height: 24),
                        CMobileTextField(
                          controller: controller.mobileNumberController,
                          selectedCountryCode: controller.selectedCountryCode,
                          onCountryCodeChanged: controller.onCountryCodeChanged,
                        ),
                        const SizedBox(height: 24),
                        CTextField(
                          keyboardType: TextInputType.text,
                          controller: controller.fullNameController,
                          validator: AppValidator.emptyNullValidator,
                          labelText: TranslationController.td.fullName,
                        ),
                        const SizedBox(height: 24),
                        CPullDownButton<String>(
                          hint: TranslationController.td.accountType,
                          selectedItem: controller.accountTypeController.text.isEmpty
                              ? null
                              : (
                                  item:
                                      "${controller.accountTypeController.text} ${TranslationController.td.account}",
                                  data: controller.accountTypeController.text
                                ),
                          items: controller.accountTypes
                              .map((type) =>
                                  (item: "$type ${TranslationController.td.account}", data: type))
                              .toList(),
                          onChanged: controller.onAccountTypeChanged,
                        ),
                        if (controller.accountTypeController.text.isNotEmpty &&
                            controller.accountTypeController.text != "Personal") ...[
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
                              ),
                            ).paddingOnly(left: 10, top: 6),
                        ],
                        const SizedBox(height: 24),
                        CPullDownButton<String>(
                          hint: TranslationController.td.currency,
                          selectedItem: (
                            item: controller.currencyController.text,
                            data: controller.currencyController.text
                          ),
                          items: controller.currencies
                              .map((currency) => (item: currency, data: currency))
                              .toList(),
                          onChanged: (({String data, String item}) selectedCurrency) {
                            controller.currencyController.text = selectedCurrency.data;
                          },
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => CTextField(
                            controller: controller.passwordController,
                            validator: AppValidator.emptyNullValidator,
                            keyboardType: TextInputType.visiblePassword,
                            labelText: TranslationController.td.password,
                            obscureText: controller.obscurePassword.value,
                            suffixIcon: selectIcon(
                              controller.obscurePassword.value
                                  ? AppIcons.eyeClosed
                                  : AppIcons.eyeOpen,
                              onPressed: () {
                                controller.obscurePassword.value =
                                    !controller.obscurePassword.value;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Obx(
                          () => CTextField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.confirmPasswordController,
                            labelText: TranslationController.td.confirmPassword,
                            obscureText: controller.obscureConfirmPassword.value,
                            suffixIcon: selectIcon(
                              controller.obscureConfirmPassword.value
                                  ? AppIcons.eyeClosed
                                  : AppIcons.eyeOpen,
                              onPressed: () {
                                controller.obscureConfirmPassword.value =
                                    !controller.obscureConfirmPassword.value;
                              },
                            ),
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return TranslationController.td.$required;
                              }
                              if (value != controller.passwordController.text.trim()) {
                                return TranslationController.td.passwordDoesNotMatch;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        CText(
                          TranslationController.td
                              .weWantToAssureYouThatWeTakeYourPrivacySeriouslyAndThatYourPersonalInformationIsSafeWeWillOnlyUseYourDetailsUnderOurPrivacyPolicyWeUseYourInformationToProvideOurServicesAndToSendNotificationsAboutYourAccountInformationOffersAndOtherThingsThatMayInterestYou,
                          style: TextThemeX.text14,
                        ),
                        const SizedBox(height: 16),
                        const _TermsConditionsConfirmation(),
                        const SizedBox(height: 16),
                        const _PrivacyPolicyConfirmation(),
                        const SizedBox(height: 40),
                        CFlatButton(
                          onPressed: controller.onRegisterMember,
                          text: TranslationController.td.register,
                          isDisabled: !controller.isTermsConditionsChecked ||
                              !controller.isPrivacyPolicyChecked,
                        ).defaultHorizontal,
                        if (Get.previousRoute == Routes.LOGIN) ...[
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                text: "${TranslationController.td.alreadyHaveAnAccount} ",
                                style: TextThemeX.text16.copyWith(color: getGrey1),
                                children: [
                                  TextSpan(
                                    text: TranslationController.td.login,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offAllNamed(Routes.LOGIN);
                                      },
                                    style: TextThemeX.text16.copyWith(color: getPrimaryColor),
                                  ),
                                ],
                              ),
                              textScaler: const TextScaler.linear(1),
                            ),
                          ),
                        ],
                        SizedBox(height: context.bottomPadding),
                      ],
                    ).defaultHorizontal,
                  ),
                ),
        );
      },
    );
  }
}

class _TermsConditionsConfirmation extends StatelessWidget {
  const _TermsConditionsConfirmation();

  @override
  Widget build(BuildContext context) {
    TextStyle text1 = TextThemeX.text14;
    TextStyle text2 = TextThemeX.text14.copyWith(
      color: getColorWhiteBlack,
      fontWeight: FontWeight.w600,
    );

    return GetBuilder<RegisterMemberController>(
      builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CCoreButton(
              onPressed: controller.onTermsConditionsChecked,
              child: Icon(
                controller.isTermsConditionsChecked
                    ? CupertinoIcons.checkmark_square_fill
                    : CupertinoIcons.square,
                color: controller.isTermsConditionsChecked ? getPrimaryColor : getGrey1,
              ).paddingOnly(right: 10),
            ),
            Expanded(
              child: CCoreButton(
                onPressed: controller.onTermsConditionsChecked,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "${TranslationController.td.iAgreeToBeBoundBy} ", style: text1),
                      TextSpan(
                          text: "${TranslationController.td.termsAndConditions} ", style: text2),
                      TextSpan(
                        text: TranslationController.td.andAcceptTheTermsOfTheQMGoldPlatform,
                        style: text1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PrivacyPolicyConfirmation extends StatelessWidget {
  const _PrivacyPolicyConfirmation();

  @override
  Widget build(BuildContext context) {
    TextStyle text1 = TextThemeX.text14;
    TextStyle text2 = TextThemeX.text14.copyWith(
      color: getColorWhiteBlack,
      fontWeight: FontWeight.w600,
    );

    return GetBuilder<RegisterMemberController>(
      builder: (controller) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CCoreButton(
              onPressed: controller.onPrivacyPolicyChecked,
              child: Icon(
                controller.isPrivacyPolicyChecked
                    ? CupertinoIcons.checkmark_square_fill
                    : CupertinoIcons.square,
                color: controller.isPrivacyPolicyChecked ? getPrimaryColor : getGrey1,
              ).paddingOnly(right: 10),
            ),
            Expanded(
              child: CCoreButton(
                onPressed: controller.onPrivacyPolicyChecked,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "${TranslationController.td.asPerThe} ", style: text1),
                      TextSpan(text: TranslationController.td.privacyPolicy, style: text2),
                      TextSpan(
                        text:
                            ", ${TranslationController.td.iConsentToCollectingUsingAndDisclosingMyPersonalInformation}",
                        style: text1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
