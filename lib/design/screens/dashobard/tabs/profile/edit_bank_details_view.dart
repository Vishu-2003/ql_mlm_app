import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'edit_bank_details_controller.dart';

class EditBankDetailsView extends StatelessWidget {
  const EditBankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBankDetailsController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.editBankDetails),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    CTextField(
                      keyboardType: TextInputType.name,
                      controller: controller.bankNameController,
                      validator: AppValidator.emptyNullValidator,
                      labelText: TranslationController.td.bankName,
                    ),
                    const SizedBox(height: 24),
                    CTextField(
                      keyboardType: TextInputType.name,
                      validator: AppValidator.emptyNullValidator,
                      controller: controller.accountHolderNameController,
                      labelText: TranslationController.td.accountHolderName,
                    ),
                    const SizedBox(height: 24),
                    CTextField(
                      keyboardType: TextInputType.number,
                      validator: AppValidator.emptyNullValidator,
                      controller: controller.accountNumberController,
                      labelText: TranslationController.td.accountNumber,
                    ),
                    const SizedBox(height: 24),
                    CTextField(
                      keyboardType: TextInputType.text,
                      controller: controller.ifscCodeController,
                      validator: AppValidator.emptyNullValidator,
                      labelText: TranslationController.td.swiftCode,
                    ),
                    const SizedBox(height: 40),
                    CFlatButton(
                      text: TranslationController.td.update,
                      onPressed: controller.updateBankDetails,
                    ).defaultHorizontal,
                    SizedBox(height: context.bottomPadding),
                  ],
                ),
              ),
            ).defaultHorizontal,
          ),
        );
      },
    );
  }
}
