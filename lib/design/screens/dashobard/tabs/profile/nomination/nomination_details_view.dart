import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';

import '/design/components/components.dart';
import '/utils/utils.dart';
import 'nomination_details_controller.dart';

// TODO: i18n

class NominationDetailsView extends StatelessWidget {
  const NominationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NominationDetailsController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "Nomination Details"),
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
                          "Nominate your loved ones to receive your Gold savings upon your demise.",
                          style: TextThemeX.text16
                              .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        CText(
                          "To allow your loved ones to conveniently receive your Gold savings in cash when you pass on, you need to include your loved ones in a QM account nomination. Before you proceed, you should work out these details:",
                          style: TextThemeX.text14,
                        ),
                        const SizedBox(height: 16),
                        CText(
                          "Nominee",
                          style: TextThemeX.text16
                              .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        CText(
                          TranslationController.td
                              .youCanAppoint1NomineeInThisFormIfYouWishToAppointMoreThan1NomineePleaseVisitTheQMServiceCentre,
                          style: TextThemeX.text14,
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: neverScrollablePhysics,
                          itemCount: controller.nomineeDetails.length,
                          itemBuilder: (context, index) {
                            return Obx(
                              () => Row(
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
                                        Row(
                                          children: [
                                            CText(
                                              "${controller.nomineeDetails[index].nomineeName} (${controller.nomineeDetails[index].share}%)",
                                              style: TextThemeX.text14.copyWith(
                                                color: getColorWhiteBlack,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            if (!isNullEmptyOrFalse(
                                                controller.nomineeDetails[index].status))
                                              CText(
                                                '| ${controller.nomineeDetails[index].status}',
                                                style: TextThemeX.text14.copyWith(
                                                  color: switch (
                                                      controller.nomineeDetails[index].status) {
                                                    "Verified" => green,
                                                    "Pending" => yellow,
                                                    _ => getGrey1,
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                        CText(
                                          "Relation: ${controller.nomineeDetails[index].relationship}",
                                          style: TextThemeX.text12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  controller.isDeletingNominee.value.isDeleting &&
                                          controller.isDeletingNominee.value.nomieeId ==
                                              controller.nomineeDetails[index].name
                                      ? defaultLoader(color: lightRed, size: 25)
                                      : CCoreButton(
                                          onPressed: () {
                                            controller
                                                .deleteNominee(controller.nomineeDetails[index]);
                                          },
                                          child: const Icon(
                                            CupertinoIcons.delete,
                                            size: 20,
                                            color: lightRed,
                                          ),
                                        ),
                                ],
                              ).paddingOnly(bottom: 15),
                            );
                          },
                        ),
                        SizedBox(height: context.bottomPadding),
                      ],
                    ).defaultHorizontal,
                  ),
                ),
        );
      },
    );
  }
}
