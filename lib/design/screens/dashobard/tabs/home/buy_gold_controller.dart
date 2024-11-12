import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qm_mlm_flutter/design/components/send_verify_transaction_otp.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class BuyGoldController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetItemModel? item;
  GetBuyOrderDetailsModel? buyOrderDetails;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(5),
    onEnded: () async {
      Get.until((route) => Get.currentRoute == Routes.DASHBOARD);
      TranslationController.td.thePriceHasExpiredPleaseTryAgain.errorSnackbar();
    },
  );

  @override
  void onInit() {
    super.onInit();
    item = GetItemModel.fromJson(Get.arguments['item']);
    _getWalletDetails();
  }

  @override
  void onClose() {
    stopWatchTimer.dispose();
    super.onClose();
  }

  // Common
  GetWalletModel? wallet;
  bool autoTradeGoldRate = false;

  Future<void> _getWalletDetails() async {
    wallet = await _homeRepository.getWalletDetails();
    update();
  }

  Future<void> addFund() async {
    Get.toNamed(Routes.DEPOSIT_FUND())?.then((value) async {
      if (value == true) {
        await Future.delayed(const Duration(seconds: 2), _getWalletDetails);
      }
    });
  }

  Future<void> showDialog() async {
    await showConfirmationDialog(
      onNegativeButtonPressed: Get.back,
      title: TranslationController.td.confirmYourBuy,
      positiveButtonTitle: TranslationController.td.confirmBuy,
      substitle: TranslationController.td
          .byClickingConfirmBuyYouEnterIntoABindingContractToPurchaseTheStatedQuantityOfMetalAtTheDisplayedPriceQMWillImmediatelyChargeForTheTotalShownAndDepositTheCorrespondingMetalIntoYourAccount,
      onPositiveButtonPressed: () async {
        Get.back();

        final OTPTransactionType? transactionType = switch (item?.itemType) {
          "Gold" => OTPTransactionType.goldBuy,
          "Contract" => OTPTransactionType.gaeBuy,
          _ => null,
        };

        if (transactionType == null) return;

        final bool? isOTPVerified =
            await sendVerifyTransactionOtp(transactionType: transactionType);

        if (isOTPVerified == true) {
          Get.context?.loaderOverlay.show();
          update();
          try {
            if ((wallet?.qmCashWallet?.cashBalanceInCurrencyVal ?? 0) <
                (buyOrderDetails?.orderDoc['down_payment'] ?? 0)) {
              return await showConfirmationDialog(
                title: TranslationController.td.insufficientBalance,
                positiveButtonTitle: TranslationController.td.topUp,
                onPositiveButtonPressed: () async {
                  Get
                    ..back()
                    ..toNamed(Routes.DEPOSIT_FUND())?.then((value) async {
                      if (value == true) {
                        await _getWalletDetails();
                      }
                    });
                },
                substitle: TranslationController
                    .td.youHaveInsufficientBalanceInYourWalletPleaseTopUpYourWallet,
              );
            }
            final GetResponseModel? response =
                await _homeRepository.createOrder(data: buyOrderDetails?.orderDoc);

            if (response?.isSuccess == true) {
              showSuccessDialog(
                successMessage: response?.message,
                title: TranslationController.td.success,
                onButtonPressed: () => Get.until((route) => Get.currentRoute == Routes.DASHBOARD),
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          } finally {
            Get.context?.loaderOverlay.hide();
            update();
          }
        }
      },
    );
  }

  Future<void> _getBuyOrderDetails({
    bool shouldSendGram = false,
    bool shouldSendAmount = false,
    bool shouldSendUnit = false,
  }) async {
    try {
      Get.context?.loaderOverlay.show();
      await _getWalletDetails();
      buyOrderDetails = await _homeRepository.getBuyOrderDetails(
        item: item?.itemName,
        itemType: item?.itemType,
        autoTrade: autoTradeGoldRate,
        autoTradePrice: double.tryParse(autoTradeGoldRateController.text),
        gram: shouldSendGram ? double.tryParse(normalGoldGramController.text) : null,
        amount: shouldSendAmount ? double.tryParse(normalGoldAmountController.text) : null,
        quantity: shouldSendUnit ? double.tryParse(contractGoldUnitController.text) : null,
      );
      stopWatchTimer
        ..onResetTimer()
        ..onStartTimer();
      update();
    } catch (e) {
      debugPrint("_getBuyOrderDetails: $e");
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  void resetTimer() {
    stopWatchTimer.onResetTimer();
    buyOrderDetails = null;
    update();
  }

  // Gold
  GlobalKey<FormState> normalGoldFormKey = GlobalKey<FormState>();
  TextEditingController normalGoldAmountController = TextEditingController();
  TextEditingController normalGoldGramController = TextEditingController();
  bool isAmountSelected = true;

  void onChanged(bool? isAmount) {
    if (isAmount == null) return;
    isAmountSelected = isAmount;
    update();
    resetTimer();
  }

  void onAmountChanged(String value) {
    normalGoldGramController.clear();
    resetTimer();
  }

  void onGramChanged(String value) {
    normalGoldAmountController.clear();
    resetTimer();
  }

  TextEditingController autoTradeGoldRateController = TextEditingController();
  void onGoldRateAutoTradeToggle(bool value) async {
    autoTradeGoldRate = value;
    if (!autoTradeGoldRate) {
      autoTradeGoldRateController.clear();
    }
    update();
    resetTimer();
  }

  void onGoldRateAutoTradeChanged(String value) {
    resetTimer();
  }

  Future<void> getGoldBuyOrderDetails() async {
    if (normalGoldFormKey.currentState?.validate() == true) {
      resetTimer();
      await _getBuyOrderDetails(
        shouldSendGram: !isAmountSelected,
        shouldSendAmount: isAmountSelected,
      );
      update();
    }
  }

  Future<void> buyNormalGold() async {
    if (normalGoldFormKey.currentState?.validate() == true) {
      await showDialog();
    }
  }

  // Contract
  GlobalKey<FormState> contractGoldFormKey = GlobalKey<FormState>();
  TextEditingController contractGoldUnitController = TextEditingController();

  bool unitRateAutoTrade = false;
  TextEditingController autoTradeUnitRateController = TextEditingController();

  void onUnitChanged(String value) {
    resetTimer();
  }

  void onUnitRateAutoTradeChanged(String value) {
    resetTimer();
  }

  void onUnitRateAutoTradeToogle(bool value) async {
    autoTradeGoldRate = value;
    update();
    if (!autoTradeGoldRate) {
      autoTradeGoldRateController.clear();
    }
    resetTimer();
  }

  Future<void> getContractBuyOrderDetails() async {
    if (contractGoldFormKey.currentState?.validate() == true) {
      await _getBuyOrderDetails(shouldSendUnit: true);
      update();
    }
  }

  Future<void> buyContract() async {
    if (contractGoldFormKey.currentState?.validate() == true) {
      await showDialog();
    }
  }
}
