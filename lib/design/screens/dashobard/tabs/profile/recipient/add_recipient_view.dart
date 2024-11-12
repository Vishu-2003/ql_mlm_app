import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/profile/recipient/add_recipient_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class AddRecipientView extends StatelessWidget {
  const AddRecipientView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddRecipientController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.addRecipient),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    CTextField(
                      keyboardType: TextInputType.text,
                      validator: AppValidator.emptyNullValidator,
                      onChanged: controller.onRecipientNumberChanged,
                      controller: controller.accountNumberController,
                      labelText: '${TranslationController.td.recipientNumber}*',
                    ),
                    const SizedBox(height: 24),
                    if (controller.memberDetails != null) ...[
                      CTextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: controller.nameController,
                        validator: AppValidator.emptyNullValidator,
                        labelText: '${TranslationController.td.recipientName}*',
                      ),
                      const SizedBox(height: 24),
                      CTextField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: controller.emailController,
                        validator: AppValidator.emailValidator,
                        textInputAction: TextInputAction.done,
                        labelText: '${TranslationController.td.recipientEmail}*',
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (controller.memberDetails == null)
                      Obx(
                        () {
                          return CFlatButton(
                            textColor: getPrimaryColor,
                            loaderColor: getPrimaryColor,
                            bgColor: Colors.transparent,
                            onPressed: controller.verifyMember,
                            text: TranslationController.td.verify,
                            border: Border.all(color: getPrimaryColor),
                          ).defaultHorizontal;
                        },
                      ),
                    if (controller.memberDetails != null)
                      CFlatButton(
                        onPressed: controller.onSubmit,
                        text: TranslationController.td.submit,
                      ).defaultHorizontal,
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
