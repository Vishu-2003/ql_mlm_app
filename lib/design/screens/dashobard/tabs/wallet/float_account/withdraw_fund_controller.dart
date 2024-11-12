import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';

class WithdrawFundController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetWalletModel? walletDetails;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    walletDetails = await _homeRepository.getWalletDetails();
    isLoading = false;
    update();
  }

  GetWithdrawalInformationModel? withdrawalInformation;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController withdrawAmountController = TextEditingController();

  Future<void> onFundWithdraw() async {
    try {
      Get.context?.loaderOverlay.show();
      final GetResponseModel? response = await _homeRepository.withdrawFund(
        withdrawFundRequest: PostWithdrawFundModel(
          amount: withdrawalInformation?.amount,
          charges: withdrawalInformation?.charges,
          bankName: withdrawalInformation?.bankName,
          ifscCode: withdrawalInformation?.ifscCode,
          actualAmount: withdrawalInformation?.actualAmount,
          accountNumber: withdrawalInformation?.accountNumber,
          chargesPercentage: withdrawalInformation?.chargesPercentage,
          bankAccountHolderName: withdrawalInformation?.bankAccountHolderName,
        ),
      );

      if (response?.isSuccess == true) {
        showSuccessDialog(
          successMessage: response?.message,
          onButtonPressed: () {
            Get
              ..back()
              ..back()
              ..back(result: true);
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> onReview() async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        Get.context?.loaderOverlay.show();
        withdrawalInformation = await _homeRepository.getWithdrawalInformation(
          amount: double.tryParse(withdrawAmountController.text.trim()),
        );
        Get.toNamed(Routes.WITHDRAW_FUND_REVIEW);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }
}
