import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/models/gold_physical_withdrawal_model.dart';
import 'package:qm_mlm_flutter/core/routes/app_pages.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/profile/gold_withdrawal_requests/gold_withdrawal_requests_list_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class GoldWithdrawalRequestsListView extends StatelessWidget {
  const GoldWithdrawalRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldWithdrawalRequestsListController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: 'Gold Withdrawal Requests'),
          body: CPagedListView<GetPhysicalGoldWithdrawalRequestModel>(
            pagingController: controller.pagingController,
            itemBuilder:
                (BuildContext context, GetPhysicalGoldWithdrawalRequestModel request, int index) {
              return CCoreButton(
                onPressed: () {
                  Get.toNamed(Routes.GOLD_WITHDRAWAL_REQUEST_DETAILS(id: request.id));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CText(
                          "${request.branch ?? na} | ${request.date ?? na}",
                          style: TextThemeX.text14.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              "${request.items.length}",
                              style: TextThemeX.text16.copyWith(
                                color: getColorWhiteBlack,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CText("Total Items", style: TextThemeX.text14),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: CText(
                                  "${request.totalPrice ?? na}",
                                  style: TextThemeX.text16.copyWith(
                                    color: getColorWhiteBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              CText("Total Amount", style: TextThemeX.text14),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        CText(
                          "${request.status}",
                          style: TextThemeX.text14.copyWith(color: request.statusColor),
                        ),
                        const SizedBox(width: 5),
                        selectIcon(AppIcons.arrowRight),
                      ],
                    ),
                    Divider(color: getOutlineColor, height: 30),
                  ],
                ),
              );
            },
          ).defaultHorizontal,
        );
      },
    );
  }
}
