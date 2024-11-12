import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'wallet_history_controller.dart';

class WalletHistoryView extends StatelessWidget {
  const WalletHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletHistoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.walletHistory),
          body: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CPullDownButton<String>(
                      hint: TranslationController.td.transactionType,
                      selectedItem: (
                        item: controller.selectedFilterType.text,
                        data: controller.selectedFilterType.text
                      ),
                      items: controller.transactionTypes
                          .map((gender) => (item: gender, data: gender))
                          .toList(),
                      onChanged: controller.onFilterTypeSelected,
                    ),
                  ),
                  const SizedBox(width: 16),
                  selectIcon(
                    AppIcons.calendar,
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        barrierColor: getBgColor.withOpacity(0.5),
                        topRadius: const Radius.circular(16),
                        builder: (context) {
                          return const _FilterBottomSheet();
                        },
                      );
                    },
                  ).defaultContainer(vP: 13, hP: 13, hM: 0),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: () => Future.sync(() => controller.pagingController.refresh()),
                  child: CPagedListView<GetWalletTransactionModel>(
                    pagingController: controller.pagingController,
                    itemBuilder:
                        (BuildContext context, GetWalletTransactionModel transaction, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              selectIcon(
                                transaction.transactionNature == "Add"
                                    ? AppIcons.incomingArrow
                                    : AppIcons.outgoingArrow,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CText(
                                            transaction.transactionType ?? na,
                                            style: TextThemeX.text16.copyWith(
                                              color: getColorWhiteBlack,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          CText(
                                            transaction.transactionDatetime ?? na,
                                            style: TextThemeX.text14.copyWith(color: getGrey1),
                                          ),
                                          const SizedBox(height: 8),
                                          CCoreButton(
                                            onPressed: () async {
                                              showCupertinoModalBottomSheet(
                                                context: context,
                                                barrierColor: getBgColor.withOpacity(0.5),
                                                topRadius: const Radius.circular(16),
                                                builder: (context) {
                                                  return _TransactionDetails(
                                                    transaction: transaction,
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                CText(
                                                  TranslationController.td.viewDetails,
                                                  style:
                                                      TextThemeX.text14.copyWith(color: getGrey1),
                                                ),
                                                const SizedBox(width: 6),
                                                selectIcon(AppIcons.arrowRight),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CText(
                                      transaction.amount ?? na,
                                      textAlign: TextAlign.end,
                                      style: TextThemeX.text16.copyWith(
                                        color: transaction.transactionNature == "Add"
                                            ? green
                                            : lightRed,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    CText(
                                      "Bal: ${transaction.balance ?? na}",
                                      textAlign: TextAlign.end,
                                      style: TextThemeX.text14.copyWith(color: getGrey1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: getOutlineColor, height: 30, indent: 30),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ).defaultHorizontal,
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletHistoryController>(
      builder: (controller) {
        return Material(
          child: Column(
            children: [
              CSelectDateRange(
                initialToDate: controller.toDate,
                initialFromDate: controller.fromDate,
                onToDateChanged: controller.onToDateChanged,
                onFromDateChanged: controller.onFromDateChanged,
              ),
              const SizedBox(height: 30),
              CFlatButton(
                text: "Reset",
                bgColor: getBgColor,
                textColor: getGrey1,
                onPressed: controller.onFilterReset,
                border: Border.all(color: getGrey1),
              ),
              const SizedBox(height: 10),
              CFlatButton(
                text: "Apply",
                onPressed: controller.onFilterApplied,
              ),
            ],
          ).prepareBottomSheet(context: context, title: "Select Date Range"),
        );
      },
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  final GetWalletTransactionModel transaction;
  const _TransactionDetails({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        color: getOutlineColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: CText(
                "Transaction Details",
                style: TextThemeX.text16.copyWith(
                  color: getColorWhiteBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CText(
              "Exchange Rate: ${transaction.exchangeRate ?? na}",
              style: TextThemeX.text16.copyWith(
                color: getPrimaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ).paddingOnly(left: 30, top: 10),
            const SizedBox(height: 12),
            Row(
              children: [
                selectIcon(
                  transaction.transactionNature == "Add"
                      ? AppIcons.incomingArrow
                      : AppIcons.outgoingArrow,
                ).paddingOnly(bottom: 15),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              transaction.status ?? na,
                              style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                            ),
                            const SizedBox(height: 6),
                            CText(
                              transaction.transactionType ?? na,
                              style: TextThemeX.text16.copyWith(
                                color: getColorWhiteBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CText(
                              transaction.transactionDatetime ?? na,
                              style: TextThemeX.text14.copyWith(color: getGrey1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CText(
                        transaction.amount ?? na,
                        textAlign: TextAlign.end,
                        style: TextThemeX.text16.copyWith(
                          fontWeight: FontWeight.bold,
                          color: transaction.transactionNature == "Add" ? green : lightRed,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CText(
                        "Bal: ${transaction.balance ?? na}",
                        textAlign: TextAlign.end,
                        style: TextThemeX.text14.copyWith(color: getGrey1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (transaction.transactionType == "Deposit") ...[
              const SizedBox(height: 24),
              _detailColumn("Payment Through :", transaction.modeOfPayment ?? na),
              const SizedBox(height: 12),
              _detailColumn("Remarks", transaction.remarks ?? na),
            ],
            if (transaction.transactionType == "Withdrawal") ...[
              const SizedBox(height: 24),
              _detailColumn(TranslationController.td.bankName, transaction.bankName ?? na),
              const SizedBox(height: 12),
              _detailColumn(
                TranslationController.td.accountHolderName,
                transaction.bankAccountHolderName ?? na,
              ),
              const SizedBox(height: 12),
              _detailColumn(
                TranslationController.td.accountNumber,
                transaction.accountNumber ?? na,
              ),
              const SizedBox(height: 12),
              _detailColumn(TranslationController.td.swiftCode, transaction.ifscCode ?? na),
            ],
            const SizedBox(height: 24),
            CFlatButton(
              onPressed: Get.back,
              text: TranslationController.td.done,
            ).defaultHorizontal,
            SizedBox(height: context.bottomPadding),
          ],
        ).paddingSymmetric(horizontal: 24),
      ),
    );
  }

  Column _detailColumn(String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CText(
          key,
          style: TextThemeX.text14.copyWith(color: getGrey1),
        ),
        CText(
          value,
          style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
        ),
      ],
    );
  }
}
