import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/utils/utils.dart';

class MerchantPaymentController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  ({bool isUsed, double amount}) useFloatBalance = (isUsed: false, amount: 0.0);
  ({bool isUsed, double amount}) useGCABalance = (isUsed: false, amount: 0.0);

  GetMerchantDetailsModel? merchantDetails;
  GetMerchantAvailableBalanceModel? availableBalance;
  GetMerchantGoldConvertAmountModel? goldConvertAmount;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      merchantDetails = GetMerchantDetailsModel.fromJson(Get.arguments);
    }
    init();
  }

  bool isLoading = false;
  void init() async {
    isLoading = true;
    update();
    availableBalance = await _homeRepository.getMerchantAvailableBalance();
    isLoading = false;
    update();
  }

  void onAmountChanged(String value) {
    EasyDebounce.debounce(
      'amount-debouncer',
      const Duration(milliseconds: 500),
      () async {
        onBalanceChecked(isFloat: useFloatBalance.isUsed, isGCA: useGCABalance.isUsed);
      },
    );
  }

  void onBalanceChecked({required bool isFloat, required bool isGCA}) {
    try {
      double payableAmount = double.parse(amountController.text.trim());

      useFloatBalance = (isUsed: false, amount: 0.0);
      useGCABalance = (isUsed: false, amount: 0.0);

      if (isFloat) {
        double amountToDeduct =
            (payableAmount >= (availableBalance?.cashBalanceInCurrencyVal ?? 0.0))
                ? availableBalance?.cashBalanceInCurrencyVal ?? 0.0
                : payableAmount;
        payableAmount -= amountToDeduct;
        useFloatBalance = (isUsed: true, amount: amountToDeduct);
      }

      if (isGCA) {
        double amountToDeduct =
            (payableAmount >= (availableBalance?.gsaHoldingConvertedValue ?? 0.0))
                ? availableBalance?.gsaHoldingConvertedValue ?? 0.0
                : payableAmount;
        payableAmount -= amountToDeduct;
        useGCABalance = (isUsed: true, amount: amountToDeduct);
      }
      update();
      getMerchantGoldConvertAmount();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  RxBool loadingGoldConvertAmount = false.obs;
  Future<void> getMerchantGoldConvertAmount() async {
    try {
      loadingGoldConvertAmount.value = true;
      goldConvertAmount = await _homeRepository.getMerchantGoldConvertAmount(
        amount: calculateRemainingPayableAmount(),
      );
      update();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      loadingGoldConvertAmount.value = false;
    }
  }

  double calculateRemainingPayableAmount() {
    double minusFloatBalance = useFloatBalance.isUsed ? useFloatBalance.amount : 0.0;
    double minusGCABalance = useGCABalance.isUsed ? useGCABalance.amount : 0.0;
    return (double.tryParse(amountController.text.trim()) ?? 0) -
        minusFloatBalance -
        minusGCABalance;
  }

  Future<void> onPay() async {
    if (loadingGoldConvertAmount.value) return;

    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      if ((goldConvertAmount?.actualAmount ?? -1) < 0) {
        "You can't pay in negative !".errorSnackbar();
        return;
      }

      await showConfirmationDialog(
        title: "Pay to ${merchantDetails?.merchantName ?? na}",
        substitle: "Are you sure you want to pay ${goldConvertAmount?.actualAmountInCurrency} ?",
        onPositiveButtonPressed: () async {
          try {
            Get.back();
            Get.context?.loaderOverlay.show();

            if ((goldConvertAmount?.actualAmount ?? 0) > 0) {
              final ({String? clientSecret, String? depositDocId, String? id})? response =
                  await _homeRepository.depositFund(
                paymentMethod: "Stripe",
                amount: goldConvertAmount!.actualAmount!,
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

            PostMerchantGoldConvertModel? details = PostMerchantGoldConvertModel(
              merchant: merchantDetails?.name,
              goldPurchaseAmount: goldConvertAmount?.actualAmount,
              actualAmount: double.parse(amountController.text.trim()),
              goldAmount: useGCABalance.isUsed ? useGCABalance.amount : 0.0,
              floatBalance: useFloatBalance.isUsed ? useFloatBalance.amount : 0.0,
            );

            final GetResponseModel? responseConvert =
                await _homeRepository.merchantGoldConvert(details: details);

            Get.context?.loaderOverlay.hide();

            if (responseConvert?.isSuccess == true) {
              await showSuccessDialog(successMessage: responseConvert?.message);
              Get.until((route) => Get.currentRoute == Routes.DASHBOARD);
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
}
