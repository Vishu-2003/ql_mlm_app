import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'beneficiary_designation_controller.dart';

class BeneficiaryDesignationView extends StatelessWidget {
  const BeneficiaryDesignationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeneficiaryDesignationController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "Beneficiary Designation"),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  CText(
                    "Peace of mind for you and your loved ones",
                    style: TextThemeX.text14,
                  ),
                  const SizedBox(height: 16),
                  CText(
                    "Make A Nomination",
                    style: TextThemeX.text16.copyWith(
                      color: getColorWhiteBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CText(
                    "Decide who receives your GOLD savings and how much each person gets upon your demise.",
                    style: TextThemeX.text14,
                  ),
                  const SizedBox(height: 16),
                  CFlatButton(
                    onPressed: () {
                      Get.toNamed(Routes.MAKE_NOMINATION_1);
                    },
                    text: "Make a Nomination",
                    textColor: getPrimaryColor,
                    bgColor: getColorBlackWhite,
                    border: Border.all(color: getPrimaryColor),
                  ).defaultHorizontal,
                  const SizedBox(height: 16),
                  CFlatButton(
                    onPressed: () {
                      Get.toNamed(Routes.NOMINATION_DETAILS);
                    },
                    textColor: getPrimaryColor,
                    bgColor: getColorBlackWhite,
                    text: "View Nomination Details",
                    border: Border.all(color: getPrimaryColor),
                  ).defaultHorizontal,
                ],
              ).defaultHorizontal,
            ),
          ),
        );
      },
    );
  }
}
