import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'commission_history_controller.dart';

class CommissionHistoryView extends StatelessWidget {
  const CommissionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommissionHistoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(
            title: TranslationController.td.commissionHistory,
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CDatePickerField(
                      labelText: "From Date",
                      initialDate: controller.fromDate,
                      onDateSelected: controller.onFromDateChanged,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CDatePickerField(
                      labelText: "To Date",
                      initialDate: controller.toDate,
                      onDateSelected: controller.onToDateChanged,
                    ),
                  ),
                ],
              ).defaultHorizontal,
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: () => Future.sync(() => controller.pagingController.refresh()),
                  child: CPagedListView<GetCommissionModel>(
                    pagingController: controller.pagingController,
                    itemBuilder: (BuildContext context, GetCommissionModel commission, int index) {
                      return _CommissionDetails(commission);
                    },
                  ),
                ).defaultHorizontal,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommissionDetails extends GetWidget<CommissionHistoryController> {
  final GetCommissionModel commission;
  const _CommissionDetails(this.commission);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            selectIcon(AppIcons.incomingArrow),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CText(
                        commission.transactionType ?? na,
                        style: TextThemeX.text16.copyWith(
                          color: getColorWhiteBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CText(
                        commission.date ?? na,
                        style: TextThemeX.text14.copyWith(color: getGrey1),
                      ),
                      const SizedBox(height: 8),
                      CText(
                        "${commission.fromAccount} | ${commission.remarks ?? na}",
                        style: TextThemeX.text14.copyWith(color: getGrey1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CText(
              commission.amount ?? na,
              style: TextThemeX.text16.copyWith(
                color: green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Divider(color: getOutlineColor, height: 30, indent: 30),
      ],
    );
  }
}
