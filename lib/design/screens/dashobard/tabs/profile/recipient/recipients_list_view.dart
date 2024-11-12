import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';

import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/profile/recipient/recipients_list_controller.dart';
import '/utils/utils.dart';

class RecipientListView extends StatelessWidget {
  const RecipientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipientListController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.recipients),
          body: controller.isLoading
              ? defaultLoader()
              : controller.recipientList.isEmpty
                  ? noDataAvailableCard(text: "You have not added any recipient yet.")
                      .paddingSymmetric(horizontal: horizontalPadding, vertical: 16)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: neverScrollablePhysics,
                      itemCount: controller.recipientList.length,
                      padding:
                          const EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 50),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            CText(
                              "#${index + 1} ",
                              style: TextThemeX.text14,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(
                                    "${controller.recipientList[index].beneficiaryName}",
                                    style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                  ),
                                  CText(
                                    "${controller.recipientList[index].beneficiaryMember}",
                                    style: TextThemeX.text12,
                                  ),
                                  CText(
                                    "${controller.recipientList[index].beneficiaryEmail}",
                                    style: TextThemeX.text12,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Obx(
                              () {
                                return controller.isDeletingBeneficiary.value.isDeleting &&
                                        controller.isDeletingBeneficiary.value.beneficiaryId ==
                                            controller.recipientList[index].name
                                    ? defaultLoader(color: lightRed, size: 25)
                                    : CCoreButton(
                                        onPressed: () {
                                          controller.deleteNominee(controller.recipientList[index]);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.delete,
                                          size: 20,
                                          color: lightRed,
                                        ),
                                      );
                              },
                            )
                          ],
                        ).paddingOnly(bottom: 15);
                      },
                    ),
          bottomNavigationBar: CFlatButton(
            onPressed: () {
              Get.toNamed(Routes.CREATE_RECIPIENT)?.then((value) {
                if (value == true) controller.init();
              });
            },
            textColor: getPrimaryColor,
            bgColor: Colors.transparent,
            border: Border.all(color: getPrimaryColor),
            text: TranslationController.td.addRecipient,
          ).bottomNavBarButton(context),
        );
      },
    );
  }
}
