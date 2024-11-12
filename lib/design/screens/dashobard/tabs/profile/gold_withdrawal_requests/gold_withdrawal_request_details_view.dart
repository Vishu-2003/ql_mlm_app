import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_request_details_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class GoldWithdrawalRequestDetailsView extends StatelessWidget {
  const GoldWithdrawalRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldWithdrawalRequestDetailsController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "Withdrawal Request Details"),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CText("${controller.details?.date}", style: TextThemeX.text14),
                            ),
                            const SizedBox(width: 10),
                            CText(
                              "${controller.details?.status}",
                              style: TextThemeX.text16.copyWith(
                                color: controller.details?.statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CText("Country:", style: TextThemeX.text14),
                                      CText(
                                        "${controller.details?.country ?? na}",
                                        style:
                                            TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CText("Region:", style: TextThemeX.text14),
                                      CText(
                                        "${controller.details?.region ?? na}",
                                        style:
                                            TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CText("Branch:", style: TextThemeX.text14),
                                      CText(
                                        "${controller.details?.branch ?? na}",
                                        style:
                                            TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (!isNullEmptyOrFalse(controller.details?.branchAddress))
                              CText(
                                "${controller.details?.branchAddress ?? na}",
                                style: TextThemeX.text14,
                              ).paddingOnly(top: 16),
                            if (!isNullEmptyOrFalse(controller.details?.deliveryAddress))
                              CText(
                                "${controller.details?.deliveryAddress ?? na}",
                                style: TextThemeX.text14,
                              ).paddingOnly(top: 16),
                          ],
                        ).defaultContainer(hP: 16, vP: 16, hM: 0),
                        const SizedBox(height: 16),
                        CText("Item Details", style: TextThemeX.text14),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: controller.details?.items.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                networkImage(
                                  imageUrl: controller.details?.items[index].image,
                                  width: 70,
                                  borderRadius: 8,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CText(
                                            "${controller.details?.items[index].qty ?? 0} x ",
                                            style: TextThemeX.text16
                                                .copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          CText(
                                            "${controller.details?.items[index].goldPhysicalWithdrawalItem ?? na} (${attachUnit(controller.details?.items[index].goldWeight)})",
                                            style: TextThemeX.text16.copyWith(
                                              color: getColorWhiteBlack,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Html(
                                        data: controller.details?.items[index].description,
                                        style: {
                                          "body": Style(
                                            margin: Margins.zero,
                                            color: getdarkGColor,
                                            fontSize: FontSize(16),
                                            padding: HtmlPaddings.zero,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ).paddingOnly(bottom: 15);
                          },
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CText("Total Gold Weight", style: TextThemeX.text14),
                            CText(
                              attachUnit(controller.details?.totalGoldWeight),
                              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CText("Gold Price", style: TextThemeX.text14),
                            CText(
                              "${controller.details?.goldPrice}",
                              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                            ),
                          ],
                        ),
                        Divider(color: getOutlineColor, height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CText("Total Price", style: TextThemeX.text14),
                            CText(
                              "${controller.details?.totalPrice}",
                              style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                            ),
                          ],
                        ),
                      ],
                    ).defaultHorizontal,
                  ),
                ),
        );
      },
    );
  }
}
