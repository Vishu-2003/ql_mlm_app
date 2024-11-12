import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../../components/send_verify_transaction_otp.dart';
import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class GoldConvertController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetWalletModel? wallet;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(5),
    onEnded: () async {
      Get.until((route) => Get.currentRoute == Routes.DASHBOARD);
      TranslationController.td.thePriceHasExpiredPleaseTryAgain.errorSnackbar();
    },
  );

  GetGSAConvertDetailsModel? goldConvertDetails;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    stopWatchTimer.dispose();
    super.onClose();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    wallet = await _homeRepository.getWalletDetails();
    isLoading = false;
    update();
  }

  bool isAmountSelected = true;

  void onChanged(bool? isAmount) {
    if (isAmount == null) return;
    isAmountSelected = isAmount;
    update();
    resetTimer();
  }

  void resetTimer() {
    stopWatchTimer.onResetTimer();
    goldConvertDetails = null;
    update();
  }

  void onAmountChanged(String value) {
    resetTimer();
  }

  void onWeightChanged(String value) {
    resetTimer();
  }

  Future<void> getGSAConvertInformation() async {
    if (formKey.currentState?.validate() != true) return;

    try {
      Get.context?.loaderOverlay.show();
      goldConvertDetails = await _homeRepository.getGSAConvertInformation(
        amount: isAmountSelected ? double.tryParse(amountController.text.trim()) : null,
        gram: !isAmountSelected ? double.tryParse(weightController.text.trim()) : null,
      );
      stopWatchTimer
        ..onResetTimer()
        ..onStartTimer();
      update();
    } catch (e) {
      debugPrint("_getGSAConvertInformation: $e");
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> onConvert() async {
    if (formKey.currentState?.validate() == true) {
      await showConfirmationDialog(
          onPositiveButtonPressed: () async {
            Get.back();

            final bool? isOTPVerified =
                await sendVerifyTransactionOtp(transactionType: OTPTransactionType.goldConvert);

            if (isOTPVerified == true) {
              try {
                Get.context?.loaderOverlay.show();
                final GetResponseModel? response =
                    await _homeRepository.createConvertOrder(data: goldConvertDetails?.orderDoc);

                if (response?.isSuccess == true) {
                  showSuccessDialog(
                    onButtonPressed: () => Get
                      ..back()
                      ..back(result: true),
                    successMessage: response?.message,
                  );
                }
              } catch (e) {
                debugPrint(e.toString());
              } finally {
                Get.context?.loaderOverlay.hide();
              }
            }
          },
          title: TranslationController.td.confirmYourConvert,
          positiveButtonTitle: TranslationController.td.confirmConvert,
          // TODO: change text
          substitle: TranslationController.td
              .byClickingConfirmSellYouAreEnteringIntoaBindingContractToSellTheStatedQuantityOfMetalAtTheStatedPriceOneGoldWillImmediatelyDebitTheTotalMetalShownFromYourAccountAndDepositTheCorrespondingCashIntoYourCashBalance);
    }
  }
}
