import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.changePassword),
          body: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Obx(
                  () => CTextField(
                    validator: AppValidator.emptyNullValidator,
                    controller: controller.oldPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: TranslationController.td.oldPassword,
                    obscureText: controller.obscureOldPassword.value,
                    suffixIcon: selectIcon(
                      controller.obscureOldPassword.value ? AppIcons.eyeClosed : AppIcons.eyeOpen,
                      onPressed: () {
                        controller.obscureOldPassword.value = !controller.obscureOldPassword.value;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => CTextField(
                    validator: AppValidator.emptyNullValidator,
                    controller: controller.newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    labelText: TranslationController.td.newPassword,
                    obscureText: controller.obscureNewPassword.value,
                    suffixIcon: selectIcon(
                      controller.obscureNewPassword.value ? AppIcons.eyeClosed : AppIcons.eyeOpen,
                      onPressed: () {
                        controller.obscureNewPassword.value = !controller.obscureNewPassword.value;
                      },
                    ),
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
