import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/core/models/models.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/wallet/gca/gold_convert_repayment_controller.dart';
import '/utils/utils.dart';

class GoldConvertRepaymentView extends StatelessWidget {
  const GoldConvertRepaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldConvertRepaymentController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CAppBar(title: "Gold Convert Repayment"),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Form(
                        key: controller.formKey,
                        child: CTextField(
                          onChanged: controller.onAmountChanged,
                          validator: AppValidator.numberValidator,
                          controller: controller.amountController,
                          labelText: "Gold Convert Repayment Amount",
                          inputFormatters: [CTextField.decimalFormatter],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CCoreButton(
                        onPressed: controller.onBalanceChecked,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              controller.useFloatBalance.isUsed
                                  ? CupertinoIcons.checkmark_square_fill
                                  : CupertinoIcons.square,
                            ).paddingOnly(right: 10, top: 3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CText(
                                    "Use Float Account Balance",
                                    style: TextThemeX.text14
                                        .copyWith(fontSize: 15, color: getColorWhiteBlack),
                                  ),
                                  const SizedBox(height: 5),
                                  CText(
                                    "Available Balance: ${controller.qmCashWallet?.cashBalanceInCurrency ?? na} (${controller.qmCashWallet?.baseCashBalanceInCurrency ?? na})",
                                    style: TextThemeX.text12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).defaultContainer(
                          hM: 0,
                          vP: 10,
                          hP: 10,
                          border: controller.useFloatBalance.isUsed
                              ? Border.all(color: getPrimaryColor)
                              : null,
                        ),
                      ).disableWidget(
                        isDisabled: (controller.qmCashWallet?.cashBalanceInCurrencyVal ?? 0) <= 0,
                      ),
                      Divider(color: getOutlineColor, height: 40),
                      Expanded(
                        child: ListView.builder(
                          physics: defaultScrollablePhysics,
                          itemCount: controller.goldConvertOpenLoans.length,
                          itemBuilder: (context, index) {
                            return _RepaymentCard(data: controller.goldConvertOpenLoans[index]);
                          },
                        ),
                      ),
                    ],
                  ).defaultHorizontal,
                ),
          bottomNavigationBar: controller.isLoading
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      "Final Payable Amount: ${controller.getActualPayableAmount()}",
                      style: TextThemeX.text14.copyWith(color: getPrimaryColor),
                    ),
                    const SizedBox(height: 10),
                    CFlatButton(
                      text: "Pay",
                      onPressed: controller.onSubmit,
                    ),
                  ],
                ).bottomNavBarButton(context),
        );
      },
    );
  }
}

class _RepaymentCard extends StatelessWidget {
  final ({TextEditingController controller, GetGoldConvertLoanModel loan}) data;
  const _RepaymentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoldConvertRepaymentController>(
      builder: (controller) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CText(
                  "Gold Convert - ${data.loan.name ?? na}",
                  style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                ),
                MenuAnchor(
                  alignmentOffset: const Offset(0, 5),
                  style: MenuStyle(
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(right: 30)),
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
                        showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: getDialogBarrierColor,
                          builder: (context) {
                            return _ViewPastRepayments(data: data).prepareBottomSheet(
                              context: context,
                              title: "Repayment History",
                            );
                          },
                        );
                      },
                      child: CCoreButton(
                        color: pullDownMenuBgColor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: pullDownMenuBgColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              selectIcon(AppIcons.history2),
                              const SizedBox(width: 8),
                              CText(
                                "View Past Repayments",
                                style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                              ),
                            ],
                          ).paddingAll(15),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.terminateRepayment(id: data.loan.name!);
                      },
                      child: CCoreButton(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: lightRed,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              selectIcon(AppIcons.close2, color: getColorWhiteBlack),
                              const SizedBox(width: 8),
                              CText(
                                "Terminate",
                                style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                              ),
                            ],
                          ).paddingAll(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            dataRow("Amount", "${data.loan.amountLabel}"),
            dataRow("Outstanding Amount", "${data.loan.outstandingAmountLabel}"),
            dataRow("Paid Amount", "${data.loan.paidAmountLabel}"),
            dataRow("GSA -> GCA", "${data.loan.gsaGold} -> ${data.loan.gcaGold}"),
            const SizedBox(height: 5),
            Row(
              children: [
                const Expanded(child: Text("Enter Repayment Amount")),
                SizedBox(
                  width: 100,
                  child: CTextField(
                    labelText: "Amount",
                    textAlign: TextAlign.end,
                    controller: data.controller,
                    validator: AppValidator.numberValidator,
                    inputFormatters: [CTextField.decimalFormatter],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ],
        ).defaultContainer(hM: 0, vP: 14, vM: 5);
      },
    );
  }
}

Widget dataRow(String? key, String? value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CText(
        key ?? na,
        style: TextThemeX.text14.copyWith(color: getGrey1),
      ),
      CText(
        value ?? na,
        style: TextThemeX.text14.copyWith(
          color: getPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ).paddingOnly(bottom: 4);
}

class _ViewPastRepayments extends StatelessWidget {
  const _ViewPastRepayments({required this.data});
  final ({TextEditingController controller, GetGoldConvertLoanModel loan}) data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Repayment ID",
                style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "Date",
                  style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Amount",
                  style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                ),
              ),
            ),
          ],
        ),
        Divider(color: getColorWhiteBlack, thickness: 0.5),
        if (data.loan.repaymentDetails?.isEmpty == true)
          Text(
            "No Repayment History Found",
            style: TextThemeX.text14.copyWith(color: getGrey1),
          ).paddingSymmetric(vertical: 10)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: neverScrollablePhysics,
            itemCount: data.loan.repaymentDetails?.length ?? 0,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "${data.loan.repaymentDetails?[index].goldConvertRepayment}",
                      style: TextThemeX.text14,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        "${data.loan.repaymentDetails?[index].date}",
                        style: TextThemeX.text14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${data.loan.repaymentDetails?[index].paidAmount}",
                        style: TextThemeX.text14,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Divider(color: getOutlineColor),
          ),
      ],
    );
  }
}
