import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'make_nomination_2_controller.dart';

class MakeNomination2View extends StatelessWidget {
  const MakeNomination2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GetBuilder<MakeNomination2Controller>(
        builder: (controller) {
          return Scaffold(
            appBar: const CAppBar(title: "Make Nomination"),
            body: controller.isLoading
                ? defaultLoader()
                : SizedBox.expand(
                    child: SingleChildScrollView(
                      physics: defaultScrollablePhysics,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          CText(
                            "Before you proceed",
                            style: TextThemeX.text18
                                .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          CText(
                            "We will notify you of the status of this nomination using your contact details retrieved below. Please ensure that the details retrieved from your QM account settings are correct. Otherwise, please update your contact details now.",
                            style: TextThemeX.text14,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(CupertinoIcons.circle_fill, size: 8, color: getColorWhiteBlack)
                                  .paddingOnly(right: 10, top: 9),
                              CText(
                                "${controller.memberDetails?.mobile}",
                                style: TextThemeX.text16.copyWith(
                                  color: getColorWhiteBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 30, bottom: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(CupertinoIcons.circle_fill, size: 8, color: getColorWhiteBlack)
                                  .paddingOnly(right: 10, top: 9),
                              CText(
                                "${controller.memberDetails?.email}",
                                style: TextThemeX.text16.copyWith(
                                  color: getColorWhiteBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 30),
                          const SizedBox(height: 24),
                          CFlatButton(
                            text: "Proceed",
                            onPressed: () {
                              Get.offAndToNamed(Routes.ADD_NOMINEE);
                            },
                            textColor: getPrimaryColor,
                            bgColor: getColorBlackWhite,
                            border: Border.all(color: getPrimaryColor),
                          ).defaultHorizontal,
                          const SizedBox(height: 16),
                        ],
                      ).defaultHorizontal,
                    ),
                  ),
          );
        },
      );
    });
  }
}
