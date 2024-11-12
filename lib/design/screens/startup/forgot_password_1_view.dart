import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/startup/forgot_password_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class ForgotPasswordView1 extends StatelessWidget {
  const ForgotPasswordView1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.forgotPassword),
          body: Form(
            key: controller.mobileNoformKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                CMobileTextField(
                  controller: controller.mobileNumberController,
                  selectedCountryCode: controller.selectedCountryCode,
                  onCountryCodeChanged: controller.onCountryCodeChanged,
                ),
                const SizedBox(height: 24),
                CFlatButton(
                  text: TranslationController.td.next,
                  onPressed: controller.onMobileNumberSubmit,
                ).defaultHorizontal,
              ],
            ).defaultHorizontal,
          ),
        );
      },
    );
  }
}
