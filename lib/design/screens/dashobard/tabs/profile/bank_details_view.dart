// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'profile_controller.dart';

class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.connectedBankAccount),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _DetailsTile(
                title: TranslationController.td.bankName,
                value: controller.profileDetails?.bankName ?? na,
              ),
              const SizedBox(height: 20),
              _DetailsTile(
                title: TranslationController.td.accountHolderName,
                value: controller.profileDetails?.bankAccountHolderName ?? na,
              ),
              const SizedBox(height: 20),
              _DetailsTile(
                title: TranslationController.td.accountNumber,
                value: controller.profileDetails?.accountNumber ?? na,
              ),
              const SizedBox(height: 20),
              _DetailsTile(
                title: TranslationController.td.swiftCode,
                value: controller.profileDetails?.ifscCode ?? na,
              ),
              const SizedBox(height: 40),
              CFlatButton(
                onPressed: () {
                  Get.toNamed(Routes.EDIT_BANK_DETAILS)?.then((value) {
                    if (value == true) controller.init();
                  });
                },
                textColor: getPrimaryColor,
                bgColor: Colors.transparent,
                border: Border.all(color: getPrimaryColor),
                text: TranslationController.td.editBankDetails,
              ).defaultHorizontal,
            ],
          ).defaultHorizontal,
        );
      },
    );
  }
}

class _DetailsTile extends StatelessWidget {
  final String title;
  final String value;
  const _DetailsTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CText(
          title,
          style: TextThemeX.text12.copyWith(color: getGrey1),
        ),
        const SizedBox(height: 2),
        CText(
          value,
          style: TextThemeX.text14.copyWith(
            color: getColorWhiteBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
