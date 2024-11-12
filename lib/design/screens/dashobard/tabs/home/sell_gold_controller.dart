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

class SellGoldController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  bool isSellGoldContract = false;

  GetItemModel? item;
  GetWalletModel? wallet;
  GetSellOrderDetailsModel? sellOrderDetails;
  bool? autoTradeConract;
  String? autoTradeContractGoldRate;
  List<GetGoldContractModel> selectedGoldContracts = <GetGoldContractModel>[];
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(5),
    onEnded: () async {
      Get.until((route) => Get.currentRoute == Routes.DASHBOARD);
      TranslationController.td.thePriceHasExpiredPleaseTryAgain.errorSnackbar();
    },
  );

  @override
  void onClose() {
    stopWatchTimer.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    init();
    item = GetItemModel.fromJson(Get.arguments['item']);
    autoTradeConract = Get.arguments['auto_trade'];
    autoTradeContractGoldRate = Get.arguments['auto_trade_rate'];
    if (Get.arguments['gold_contracts'] != null) {
      isSellGoldContract = true;
      selectedGoldContracts = (Get.arguments['gold_contracts'] as List<dynamic>)
          .map((e) => GetGoldContractModel.fromJson(e))
          .toList();
      getSellContractOrderDetails();
    }
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    wallet = await _homeRepository.getWalletDetails();
    isLoading = false;
    update();
  }

  // Common
  Future<void> showDialog() async {
    await showConfirmationDialog(
      onPositiveButtonPressed: () async {
        Get.back();

        final OTPTransactionType? transactionType = switch (item?.itemType) {
          "Gold" => OTPTransactionType.goldSell,
          "Contract" => OTPTransactionType.gaeSell,
          _ => null,
        };

        if (transactionType == null) return;

        final bool? isOTPVerified =
            await sendVerifyTransactionOtp(transactionType: transactionType);

        if (isOTPVerified == true) {
          Get.context?.loaderOverlay.show();
          try {
            final GetResponseModel? response =
                await _homeRepository.createOrder(data: sellOrderDetails?.orderDoc);
            if (response?.isSuccess == true) {
              showSuccessDialog(
                title: TranslationController.td.success,
                successMessage: response?.message,
                onButtonPressed: () => Get.until((route) => Get.currentRoute == Routes.DASHBOARD),
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          } finally {
            Get.context?.loaderOverlay.hide();
          }
        }
      },
      onNegativeButtonPressed: Get.back,
      title: TranslationController.td.confirmYourSell,
      positiveButtonTitle: TranslationController.td.confirmSell,
      // TODO: change text
      substitle: TranslationController.td
          .byClickingConfirmSellYouAreEnteringIntoaBindingContractToSellTheStatedQuantityOfMetalAtTheStatedPriceOneGoldWillImmediatelyDebitTheTotalMetalShownFromYourAccountAndDepositTheCorrespondingCashIntoYourCashBalance,
    );
  }

  // Gold
  bool autoTrade = false;
  bool isAmountSelected = true;

  void resetTimer() {
    stopWatchTimer.onResetTimer();
    sellOrderDetails = null;
    update();
  }

  void onChanged(bool? isAmount) {
    if (isAmount == null) return;
    isAmountSelected = isAmount;
    update();
    resetTimer();
  }

  void onAutoTradeToggled(bool value) {
    autoTrade = value;
    update();
    if (!autoTrade) {
      autoTradeGoldRateController.clear();
    }
    resetTimer();
  }

  TextEditingController autoTradeGoldRateController = TextEditingController();

  GlobalKey<FormState> normalGoldFormKey = GlobalKey<FormState>();
  TextEditingController normalGoldAmountController = TextEditingController();
  TextEditingController normalGoldGramController = TextEditingController();

  void onAmountChanged(String value) {
    normalGoldGramController.clear();
    resetTimer();
  }

  void onGramChanged(String value) {
    normalGoldAmountController.clear();
    resetTimer();
  }

  void onGoldRateAutoTradeChanged(String value) {
    resetTimer();
  }

  Future<void> getGoldSellOrderDetails() async {
    if (normalGoldFormKey.currentState?.validate() == true) {
      try {
        Get.context?.loaderOverlay.show();
        sellOrderDetails = await _homeRepository.getSellOrderDetailsGold(
          item: item?.itemName,
          autoTrade: autoTrade,
          itemType: item?.itemType,
          autoTradePrice: double.tryParse(autoTradeGoldRateController.text.trim()),
          gram: isAmountSelected ? null : double.tryParse(normalGoldGramController.text),
          amount: isAmountSelected ? double.tryParse(normalGoldAmountController.text) : null,
        );
        stopWatchTimer
          ..onResetTimer()
          ..onStartTimer();
        update();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        Get.context?.loaderOverlay.hide();
      }
    }
  }

  Future<void> sellNormalGold() async {
    if (normalGoldFormKey.currentState?.validate() == true) {
      await showDialog();
    }
  }

  // Contract

  Future<void> getSellContractOrderDetails() async {
    try {
      sellOrderDetails = await _homeRepository.getSellOrderDetailsContract(
        data: PostSellOrderDetailsContractModel(
          item: item?.itemName,
          autoTrade: autoTradeConract,
          autoTradePrice: double.tryParse(autoTradeContractGoldRate ?? ""),
          contracts: selectedGoldContracts
              .map((contract) => Contracts(qty: contract.qty, name: contract.id))
              .toList(),
        ),
      );
      stopWatchTimer
        ..onResetTimer()
        ..onStartTimer();
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sellContractGold() async {
    await showDialog();
  }
}
