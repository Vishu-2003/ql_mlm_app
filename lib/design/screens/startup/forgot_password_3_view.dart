import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/startup/forgot_password_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class ForgotPasswordView3 extends StatelessWidget {
  const ForgotPasswordView3({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: 'New Password'),
          body: Form(
            key: controller.newPasswordformKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Obx(
                  () => CTextField(
                    validator: AppValidator.emptyNullValidator,
                    controller: controller.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: TranslationController.td.password,
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: selectIcon(
                      controller.obscurePassword.value ? AppIcons.eyeClosed : AppIcons.eyeOpen,
                      onPressed: () {
                        controller.obscurePassword.value = !controller.obscurePassword.value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => CTextField(
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
                      if (value?.isEmpty == true) {
                        return "required!";
                      }
                      if (value != controller.passwordController.text.trim()) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                CFlatButton(
                  onPressed: controller.changePassword,
                  text: TranslationController.td.update,
                ).defaultHorizontal,
              ],
            ).defaultHorizontal,
          ),
        );
      },
    );
  }
}
