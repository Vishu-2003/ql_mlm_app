import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:qm_mlm_flutter/core/models/history_models.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/history/history_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      init: Get.find<HistoryController>(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CPullDownButton<HistoryType>(
                      hint: "",
                      position: PullDownMenuPosition.over,
                      onChanged: (({HistoryType data, String item}) value) {
                        controller.onHistoryTypeSelected(value.data);
                      },
                      selectedItem: (
                        data: controller.selectedHistoryType,
                        item: controller.selectedHistoryType.value,
                      ),
                      items:
                          HistoryType.values.map((type) => (item: type.value, data: type)).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (controller.selectedHistoryType == HistoryType.memberGaeHistory) ...[
                    selectIcon(
                      AppIcons.user2,
                      onPressed: () async {
                        await showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: getDialogBarrierColor,
                          builder: (context) {
                            return CSelectionSheet(
                              items: controller.directMembers
                                  .map(
                                    (member) => SelectionSheetItem(
                                      id: member.name,
                                      subtitle: member.name,
                                      title: member.memberName,
                                    ),
                                  )
                                  .toList(),
                              sheetTitle: "Select Member",
                              onSelected: controller.onMemberGaeHistorySelected,
                              selectedItems: [
                                if (controller.selectedMemberGaeHistory != null)
                                  controller.selectedMemberGaeHistory!,
                              ],
                            );
                          },
                        );
                      },
                    ).defaultContainer(vP: 13, hP: 13, hM: 0),
                    const SizedBox(width: 12),
                  ],
                  selectIcon(
                    AppIcons.calendar,
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        barrierColor: getBgColor.withOpacity(0.5),
                        topRadius: const Radius.circular(16),
                        builder: (context) {
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
                                const SizedBox(height: 30),
                              ],
                            ).prepareBottomSheet(context: context, title: "Select Date Range"),
                          );
                        },
                      );
                    },
                  ).defaultContainer(vP: 13, hP: 13, hM: 0),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: switch (controller.selectedHistoryType) {
                  HistoryType.gaeHistory => const _TradeHistoryListView(),
                  HistoryType.memberGaeHistory => const _MemberTradeHistoryListView(),
                  HistoryType.gsaHistory => const _GSAHistoryListView(),
                  HistoryType.withdrawalHistory => const _WithdrawalHistoryListView(),
                  HistoryType.depositHistory => const _DepositHistoryListView(),
                  HistoryType.qmGoldAutoTradeHistory => const _AutoTradeGoldHistoryListView(),
                  HistoryType.gaexAutoTradeHistory => const _AutoTradeContractHistoryListView(),
                },
              ),
            ],
          ).defaultHorizontal,
        );
      },
    );
  }
}

class _TradeHistoryListView extends GetWidget<HistoryController> {
  const _TradeHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.tradeHistoryPagingController.refresh()),
      child: CPagedListView<GetTradeHistoryModel>(
        pagingController: controller.tradeHistoryPagingController,
        itemBuilder: (BuildContext context, GetTradeHistoryModel trade, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CText(
                    "${trade.status ?? na}",
                    style: TextThemeX.text16.copyWith(
                      color: trade.getStatusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  CText(
                    "${trade.transactionType ?? na}",
                    style: TextThemeX.text16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: trade.getTransactionTypeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CText(
                      "${trade.product ?? na} (Qty: ${trade.qty ?? na})",
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CText(
                      attachUnit(trade.estimatedGold),
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Exchange Rate", trade.exchangeRate),
              _KeyValueRow("Order Date", trade.orderDate),
              _KeyValueRow(TranslationController.td.paid, trade.downPayment),
              _KeyValueRow(TranslationController.td.total, trade.totalAmount),
              _KeyValueRow("Maturity Date", trade.flexiPaymentDate),
              _KeyValueRow("Flexi Payment", trade.flexiPayment),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _MemberTradeHistoryListView extends GetWidget<HistoryController> {
  const _MemberTradeHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.memberTradeHistoryPagingController.refresh()),
      child: CPagedListView<GetTradeHistoryModel>(
        pagingController: controller.memberTradeHistoryPagingController,
        itemBuilder: (BuildContext context, GetTradeHistoryModel trade, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CText(
                    "${trade.status ?? na}",
                    style: TextThemeX.text16.copyWith(
                      color: trade.getStatusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  CText(
                    "${trade.transactionType ?? na}",
                    style: TextThemeX.text16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: trade.getTransactionTypeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CText(
                      "${trade.product ?? na} (Qty: ${trade.qty ?? na})",
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CText(
                      attachUnit(trade.estimatedGold),
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Member Name", trade.member),
              _KeyValueRow("Exchange Rate", trade.exchangeRate),
              _KeyValueRow("Order Date", trade.orderDate),
              _KeyValueRow(TranslationController.td.paid, trade.downPayment),
              _KeyValueRow(TranslationController.td.total, trade.totalAmount),
              _KeyValueRow("Maturity Date", trade.flexiPaymentDate),
              _KeyValueRow("Flexi Payment", trade.flexiPayment),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _GSAHistoryListView extends GetWidget<HistoryController> {
  const _GSAHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.gsaHistoryPagingController.refresh()),
      child: CPagedListView<GetGSAHistoryModel>(
        pagingController: controller.gsaHistoryPagingController,
        itemBuilder: (BuildContext context, GetGSAHistoryModel gsa, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!isNullEmptyOrFalse(gsa.receivedFrom))
                    CText(
                      "From: ${gsa.receivedFrom}",
                      style: TextThemeX.text16.copyWith(fontWeight: FontWeight.w600),
                    )
                  else if (!isNullEmptyOrFalse(gsa.transferTo))
                    CText(
                      "To: ${gsa.transferTo}",
                      style: TextThemeX.text16.copyWith(fontWeight: FontWeight.w600),
                    ),
                  const Spacer(),
                  CText(
                    "${gsa.transactionType ?? na}",
                    style: TextThemeX.text16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: gsa.getTransactionTypeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CText(
                      "${gsa.transactionId ?? na}",
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CText(
                      attachUnit(gsa.estimatedGold),
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Exchange Rate", gsa.exchangeRate),
              _KeyValueRow("Order Date", gsa.orderDate),
              _KeyValueRow("Amount", gsa.amount),
              _KeyValueRow("Total GSA Balance", gsa.totalGsaBalance),
              _KeyValueRow("Gold Rate", gsa.goldRate),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _WithdrawalHistoryListView extends GetWidget<HistoryController> {
  const _WithdrawalHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.withdrawalPagingController.refresh()),
      child: CPagedListView<GetWithdrawalHistoryModel>(
        pagingController: controller.withdrawalPagingController,
        itemBuilder: (BuildContext context, GetWithdrawalHistoryModel withdrawal, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CText(
                      withdrawal.status ?? na,
                      style: TextThemeX.text16.copyWith(
                        fontWeight: FontWeight.bold,
                        color: withdrawal.getStatsColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CText(
                    withdrawal.date ?? na,
                    style: TextThemeX.text14.copyWith(color: getGrey1),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              _KeyValueRow("Exchange Rate", withdrawal.exchangeRate),
              const SizedBox(height: 3),
              CText(
                "${withdrawal.amount} - ${withdrawal.charges} = ${withdrawal.actualAmount}",
                style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
              ),
              const SizedBox(height: 3),
              CCoreButton(
                onPressed: () async {
                  showCupertinoModalBottomSheet(
                    context: context,
                    topRadius: const Radius.circular(16),
                    barrierColor: getBgColor.withOpacity(0.5),
                    builder: (context) {
                      return withdrawalHistoryDetails(context, withdrawal);
                    },
                  );
                },
                child: Row(
                  children: [
                    CText(
                      TranslationController.td.viewDetails,
                      style: TextThemeX.text14.copyWith(color: getGrey1),
                    ),
                    const SizedBox(width: 6),
                    selectIcon(AppIcons.arrowRight),
                  ],
                ),
              ),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }

  Material withdrawalHistoryDetails(BuildContext context, GetWithdrawalHistoryModel withdrawal) {
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
                "Withdrawal Details",
                style: TextThemeX.text16.copyWith(
                  color: getColorWhiteBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CText(
                  withdrawal.date ?? na,
                  style: TextThemeX.text16.copyWith(color: getGrey1),
                ),
                CText(
                  withdrawal.status ?? na,
                  style: TextThemeX.text16.copyWith(color: withdrawal.getStatsColor),
                ),
              ],
            ),
            _KeyValueRow("Exchange Rate", withdrawal.exchangeRate),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerRight,
              child: CText(
                "${withdrawal.amount} - ${withdrawal.charges} = ${withdrawal.actualAmount}",
                style: TextThemeX.text14
                    .copyWith(fontWeight: FontWeight.bold, color: getColorWhiteBlack),
              ),
            ),
            const SizedBox(height: 24),
            _detailColumn(TranslationController.td.bankName, withdrawal.bankName ?? na),
            const SizedBox(height: 12),
            _detailColumn(
              TranslationController.td.accountHolderName,
              withdrawal.bankAccountHolderName ?? na,
            ),
            const SizedBox(height: 12),
            _detailColumn(
              TranslationController.td.accountNumber,
              withdrawal.accountNumber ?? na,
            ),
            const SizedBox(height: 12),
            _detailColumn(TranslationController.td.swiftCode, withdrawal.swiftCode ?? na),
            const SizedBox(height: 24),
            CFlatButton(
              text: TranslationController.td.done,
              onPressed: () => Navigator.pop(context),
            ).defaultHorizontal,
            SizedBox(height: context.bottomPadding + 30),
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

class _DepositHistoryListView extends GetWidget<HistoryController> {
  const _DepositHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.depositPagingController.refresh()),
      child: CPagedListView<GetDepositHistoryModel>(
        pagingController: controller.depositPagingController,
        itemBuilder: (BuildContext context, GetDepositHistoryModel deposit, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    deposit.status ?? na,
                    style: TextThemeX.text16
                        .copyWith(fontWeight: FontWeight.w600, color: deposit.getStatsColor),
                  ),
                  CText(
                    "Payment: ${deposit.modeOfPayment ?? na}",
                    style: TextThemeX.text16.copyWith(
                      color: getGrey1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CText(
                    deposit.date ?? na,
                    style: TextThemeX.text16.copyWith(
                      color: getColorWhiteBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  CText(
                    deposit.amount ?? na,
                    style: TextThemeX.text16.copyWith(
                      color: getColorWhiteBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Exchange Rate", deposit.exchangeRate),
              _KeyValueRow("Remarks", deposit.remarks),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _AutoTradeGoldHistoryListView extends GetWidget<HistoryController> {
  const _AutoTradeGoldHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.goldAutoTradePagingController.refresh()),
      child: CPagedListView<GetAutoTradeOrderHistoryModel>(
        pagingController: controller.goldAutoTradePagingController,
        itemBuilder: (BuildContext context, GetAutoTradeOrderHistoryModel trade, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CText(
                    trade.status ?? na,
                    style: TextThemeX.text16.copyWith(
                      color: trade.getStatsColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 5),
                  CText(
                    trade.transactionType ?? na,
                    style: TextThemeX.text16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: trade.transactionType == "Buy" ? green : lightRed,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (trade.status == "Pending")
                    _CancelAutoTradeOrderButton(
                      tradeId: trade.id,
                      transactionType: trade.transactionType == "Buy"
                          ? OTPTransactionType.cancelGoldBuyAutoTrade
                          : OTPTransactionType.cancelGoldSellAutoTrade,
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CText(
                      trade.tradingItem ?? na,
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CText(
                      attachUnit(trade.totalEstimatedGold),
                      style: TextThemeX.text16.copyWith(
                        color: getColorWhiteBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Exchange Rate", trade.exchangeRate),
              _KeyValueRow("Posting Date", trade.postingDate),
              _KeyValueRow("Trade Price", trade.autoTradePrice),
              _KeyValueRow("Total Price", trade.totalPrice),
              _KeyValueRow("Down Payment", trade.downPayment),
              _KeyValueRow("Flexible Payment", trade.flexiblePayment),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _CancelAutoTradeOrderButton extends StatelessWidget {
  final String tradeId;
  final OTPTransactionType transactionType;

  const _CancelAutoTradeOrderButton({
    required this.tradeId,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      builder: (controller) {
        return MenuAnchor(
          alignmentOffset: const Offset(0, 5),
          style: MenuStyle(
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(const EdgeInsets.only(right: 10)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          builder: (BuildContext context, MenuController controller, Widget? child) {
            return CCoreButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Icon(Icons.more_vert, color: getColorWhiteBlack),
            );
          },
          menuChildren: [
            GestureDetector(
              onTap: () {
                controller.cancelAutoTradeOrder(
                  orderId: tradeId,
                  transactionType: transactionType,
                );
              },
              child: CCoreButton(
                child: Container(
                  decoration: BoxDecoration(
                    color: lightRed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      selectIcon(AppIcons.close2, color: getColorWhiteBlack),
                      const SizedBox(width: 8),
                      CText(
                        "Cancel Order",
                        style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                      ),
                    ],
                  ).paddingAll(15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AutoTradeContractHistoryListView extends GetWidget<HistoryController> {
  const _AutoTradeContractHistoryListView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => controller.contractAutoTradePagingController.refresh()),
      child: CPagedListView<GetAutoTradeOrderHistoryModel>(
        pagingController: controller.contractAutoTradePagingController,
        itemBuilder: (BuildContext context, GetAutoTradeOrderHistoryModel trade, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CText(
                    trade.status ?? na,
                    style: TextThemeX.text16.copyWith(
                      color: trade.getStatsColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 5),
                  CText(
                    trade.transactionType ?? na,
                    style: TextThemeX.text16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: trade.transactionType == "Buy" ? green : lightRed,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (trade.status == "Pending")
                    _CancelAutoTradeOrderButton(
                      tradeId: trade.id,
                      transactionType: trade.transactionType == "Buy"
                          ? OTPTransactionType.cancelGAEBuyAutoTrade
                          : OTPTransactionType.cancelGAESellAutoTrade,
                    ),
                ],
              ),
              const SizedBox(height: 5),
              CText(
                trade.tradingItem ?? na,
                style: TextThemeX.text16.copyWith(
                  color: getColorWhiteBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              _KeyValueRow("Exchange Rate", trade.exchangeRate),
              _KeyValueRow("Posting Date", trade.postingDate),
              _KeyValueRow("Trade Price", trade.autoTradePrice),
              _KeyValueRow("Total Price", trade.totalPrice),
              _KeyValueRow("Down Payment", trade.downPayment),
              _KeyValueRow("Flexible Payment", trade.flexiblePayment),
              _KeyValueRow("Contract Price", trade.contractPrice),
              _KeyValueRow("Contract Weight", trade.contractWeight),
              Divider(color: getOutlineColor, height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final dynamic title;
  final dynamic value;
  const _KeyValueRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CText(
            "${title ?? na} :",
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          flex: 3,
          child: CText(
            "${value ?? na}",
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ),
        ),
      ],
    );
  }
}
