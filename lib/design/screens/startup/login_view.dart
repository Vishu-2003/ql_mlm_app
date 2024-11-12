import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/startup/login_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Form(
            key: controller.formKey,
            child: SizedBox.expand(
              child: SingleChildScrollView(
                physics: defaultScrollablePhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.topPadding),
                    Center(child: selectImage(AppImages.logo2, width: 225)),
                    const SizedBox(height: 24),
                    Center(
                      child: CupertinoSlidingSegmentedControl<LoginType>(
                        backgroundColor: getBg2,
                        thumbColor: getPrimaryColor,
                        groupValue: controller.selectedLoginType,
                        onValueChanged: controller.onLoginTypeChanged,
                        children: <LoginType, Widget>{
                          LoginType.username: CText(
                            'Email',
                            style: TextThemeX.text14.copyWith(color: getLightGold),
                          ).paddingSymmetric(horizontal: 20),
                          LoginType.mobile: CText(
                            'Mobile',
                            style: TextThemeX.text14.copyWith(color: getLightGold),
                          ).paddingSymmetric(horizontal: 20),
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    controller.selectedLoginType == LoginType.mobile
                        ? CMobileTextField(
                            controller: controller.mobileController,
                            selectedCountryCode: controller.selectedCountryCode,
                            onCountryCodeChanged: controller.onCountryCodeChanged,
                          )
                        : CTextField(
                            labelText:
                                "${TranslationController.td.email} / ${TranslationController.td.userName}",
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidator.emptyNullValidator,
                            controller: controller.userNameController,
                          ),
                    const SizedBox(height: 24),
                    Obx(
                      () => CTextField(
                        textInputAction: TextInputAction.done,
                        controller: controller.passwordController,
                        validator: AppValidator.emptyNullValidator,
                        labelText: TranslationController.td.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: controller.obscurePassword.value,
                        suffixIcon: selectIcon(
                          controller.obscurePassword.value ? AppIcons.eyeClosed : AppIcons.eyeOpen,
                          onPressed: () {
                            controller.obscurePassword.value = !controller.obscurePassword.value;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CCoreButton(
                        onPressed: () {
                          Get.toNamed(Routes.FORGOT_PASSWORD_1);
                        },
                        child: CText(
                          '${TranslationController.td.forgotPassword}?',
                          style: TextThemeX.text14.copyWith(
                            color: getPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => CPullDownButton<GetLanguageModel>(
                        onChanged: controller.changeLanguage,
                        hint: TranslationController.td.language,
                        selectedItem: controller.selectedLanguage.value,
                        items: controller.languages
                            .map((e) => (item: e.languageName, data: e))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text.rich(
                      TextSpan(
                        text:
                            "${TranslationController.td.byClickingLoginIDeclareThatIHaveReadUnderstoodAndAccepted} ",
                        style: TextThemeX.text16.copyWith(color: getGrey1),
                        children: [
                          TextSpan(
                            text: TranslationController.td.termsAndConditions,
                            style: TextThemeX.text16.copyWith(color: getPrimaryColor),
                          ),
                        ],
                      ),
                      textScaler: const TextScaler.linear(1),
                    ),
                    const SizedBox(height: 24),
                    CFlatButton(
                      onPressed: controller.signIn,
                      text: TranslationController.td.login,
                    ).defaultHorizontal,
                    const SizedBox(height: 24),
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
                          onPressed: controller.onGoogleSignIn,
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
                          onPressed: controller.onFacebookSignIn,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: "${TranslationController.td.dontHaveAnAccount} ",
                          style: TextThemeX.text16.copyWith(color: getGrey1),
                          children: [
                            TextSpan(
                              text: TranslationController.td.registerNow,
                              style: TextThemeX.text16.copyWith(color: getPrimaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.SIGNUP());
                                },
                            ),
                          ],
                        ),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      child: CText(
                        'v${controller.appVersion}',
                        style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                      ),
                    ),
                  ],
                ).defaultHorizontal,
              ),
            ),
          ),
        );
      },
    );
  }
}
