import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qm_mlm_flutter/core/routes/app_pages.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/wallet/gca/gold_convert_repayment_view.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';

import '../../../../../components/send_verify_transaction_otp.dart';
import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/utils/utils.dart';

class GoldConvertRepaymentController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  QmCashWallet? qmCashWallet;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<({GetGoldConvertLoanModel loan, TextEditingController controller})> goldConvertOpenLoans =
      [];

  TextEditingController amountController = TextEditingController();

  ({bool isUsed, double amount}) useFloatBalance = (isUsed: false, amount: 0.0);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    qmCashWallet = (await _homeRepository.getWalletDetails())?.qmCashWallet;
    List<GetGoldConvertLoanModel> response = await _homeRepository.getGoldConvertOpenOrders();
    goldConvertOpenLoans =
        response.map((e) => (loan: e, controller: TextEditingController())).toList();
    isLoading = false;
    update();
  }

  void onBalanceChecked() {
    if (useFloatBalance.isUsed) {
      useFloatBalance = (isUsed: false, amount: 0.0);
    } else {
      double payableAmount = double.parse(amountController.text.trim());

      double amountToDeduct = (payableAmount >= (qmCashWallet?.cashBalanceInCurrencyVal ?? 0.0))
          ? qmCashWallet?.cashBalanceInCurrencyVal ?? 0.0
          : payableAmount;
      payableAmount -= amountToDeduct;
      useFloatBalance = (isUsed: true, amount: amountToDeduct);
    }
    update();
  }

  void onAmountChanged(_) {
    update();
  }

  double getActualPayableAmount() {
    return (double.tryParse(amountController.text.trim()) ?? 0) -
        (useFloatBalance.isUsed ? useFloatBalance.amount : 0);
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() == true) {
      await showConfirmationDialog(
        title: "Confirm your Repayment",
        substitle: "are you sure want to proceed?",
        onPositiveButtonPressed: () async {
          try {
            Get.back();

            final bool? isOTPVerified = await sendVerifyTransactionOtp(
              transactionType: OTPTransactionType.goldConvertRepayment,
            );

            if (isOTPVerified == true) {
              Get.context?.loaderOverlay.show();

              double actualPayableAmount = getActualPayableAmount();

              if (actualPayableAmount > 0) {
                final ({String? clientSecret, String? depositDocId, String? id})? response =
                    await _homeRepository.depositFund(
                  paymentMethod: "Stripe",
                  amount: actualPayableAmount,
                );

                if (!isNullEmptyOrFalse(response?.depositDocId)) {
                  Stripe.publishableKey =
                      Get.find<HomeController>().dashboardDetails!.settings!.stripeKey!;

                  await Stripe.instance.initPaymentSheet(
                    paymentSheetParameters: SetupPaymentSheetParameters(
                      customFlow: false,
                      style: ThemeMode.dark,
                      merchantDisplayName: 'Quantum Metal',
                      paymentIntentClientSecret: response?.clientSecret,
                      appearance: PaymentSheetAppearance(
                        colors: PaymentSheetAppearanceColors(
                          error: lightRed,
                          background: getBg1,
                          primary: getPrimaryColor,
                          placeholderText: getGrey1,
                          componentBackground: getBg2,
                          secondaryText: getPrimaryTextColor,
                          componentText: getColorWhiteBlack,
                          primaryText: getPrimaryTextColor,
                        ),
                      ),
                    ),
                  );
                  await Stripe.instance.presentPaymentSheet();
                }
              }

              List<PostGoldConvertRepaymentModel> selectedRepayments = [];

              for (({GetGoldConvertLoanModel loan, TextEditingController controller}) repayment
                  in goldConvertOpenLoans) {
                if (repayment.controller.text.trim().isNotEmpty) {
                  selectedRepayments.add(PostGoldConvertRepaymentModel(
                    amount: repayment.loan.amount,
                    qmConvertOrder: repayment.loan.name,
                    outstandingAmount: repayment.loan.outstandingAmount,
                    paidAmount: double.parse(repayment.controller.text.trim()),
                  ));
                }
              }

              GetResponseModel? response = await _homeRepository.goldConvertRepayment(
                repayments: selectedRepayments,
                amount: double.parse(amountController.text),
              );

              if (response?.isSuccess == true) {
                showSuccessDialog(
                  successMessage: response?.message,
                  onButtonPressed: () => Get
                    ..back()
                    ..back(result: true),
                );
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          } finally {
            Get.context?.loaderOverlay.hide();
          }
        },
      );
    }
  }

  Future<void> terminateRepayment({required String id}) async {
    Rx<GetWalletModel?> wallet;
    GetTerminateGoldConvertModel? terminateGoldConvert;

    Get.context?.loaderOverlay.show();
    wallet = (await _homeRepository.getWalletDetails()).obs;
    terminateGoldConvert = await _homeRepository.terminateGoldConvert(goldConvertId: id);
    Get.context?.loaderOverlay.hide();

    if (wallet.value == null || terminateGoldConvert == null) return;

    bool lowWalletBalance = terminateGoldConvert.amountDifference! >
        wallet.value!.qmCashWallet!.cashBalanceInCurrencyVal!;

    await showConfirmationDialog(
      title: "Terminate Gold Convert",
      substitle: "Are you sure you want to terminate this gold convert?",
      positiveButtonTitle:
          terminateGoldConvert.pay && lowWalletBalance ? "Deposit Fund" : "Terminate",
      bottomChild: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: neverScrollablePhysics,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: terminateGoldConvert.qmGoldConvertTerminateRequestDetails.length,
            itemBuilder: (context, index) {
              GetGoldConvertTerminateRequestDetailsModel details =
                  terminateGoldConvert!.qmGoldConvertTerminateRequestDetails[index];
              return dataRow(details.key, details.value);
            },
          ),
          Row(
            children: [
              CText(
                "${TranslationController.td.walletBalance}: ",
                style: TextThemeX.text14.copyWith(
                  color: terminateGoldConvert.pay && lowWalletBalance ? lightRed : green,
                ),
              ),
              CText(
                wallet.value!.qmCashWallet?.cashBalanceInCurrency ?? na,
                style: TextThemeX.text14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: terminateGoldConvert.pay && lowWalletBalance ? lightRed : green,
                ),
              ),
            ],
          ),
        ],
      ),
      onPositiveButtonPressed: () async {
        try {
          if (terminateGoldConvert!.amountDifference == null) return;
          if (wallet.value!.qmCashWallet?.cashBalanceInCurrencyVal == null) return;

          if (terminateGoldConvert.pay && lowWalletBalance) {
            await Get.toNamed(Routes.DEPOSIT_FUND(
              amount: terminateGoldConvert.amountDifference! -
                  wallet.value!.qmCashWallet!.cashBalanceInCurrencyVal!,
            ));
            Get.back();
            return terminateRepayment(id: id);
          }

          Get.context?.loaderOverlay.show();
          GetResponseModel? response =
              await _homeRepository.confirmTerminateRequest(requestId: terminateGoldConvert.id);
          Get.context?.loaderOverlay.hide();
          Get.back();

          if (response?.isSuccess == true) {
            showSuccessDialog(successMessage: response?.message);
          }
          await init();
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }
}
