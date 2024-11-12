import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../components/send_verify_transaction_otp.dart';
import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';

class GoldTransferController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<GetBeneficiaryModel> beneficiaryList = [];
  GetGoldPhysicalWithdrawalDataModel? getGoldWalletDetails;

  SelectionSheetItem? selectedBeneficiary;
  TextEditingController amountController = TextEditingController();
  TextEditingController gramController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  void init() async {
    isLoading = true;
    update();
    List response = await Future.wait([
      _homeRepository.getGoldPhysicalWithdrawalData(),
      _homeRepository.getBeneficiaries(),
    ]);
    getGoldWalletDetails = response[0];
    beneficiaryList = response[1];
    isLoading = false;
    update();
  }

  void onBeneficiaryChanged(SelectionSheetItem? value) {
    selectedBeneficiary = value;
    update();
  }

  bool isAmountSelected = true;

  void onChanged(bool? isAmount) {
    if (isAmount == null) return;
    isAmountSelected = isAmount;
    update();
  }

  void onTransfer() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      await showConfirmationDialog(
        title: "Gold Transfer",
        substitle: "Are you sure you want to transfer gold?",
        onPositiveButtonPressed: () async {
          Get.back();

          final bool? isOTPVerified =
              await sendVerifyTransactionOtp(transactionType: OTPTransactionType.goldTransfer);

          if (isOTPVerified == true) {
            Get.context?.loaderOverlay.show();

            PostGoldTransferModel data = PostGoldTransferModel(
              toAccount: selectedBeneficiary?.id,
              transferMode: isAmountSelected ? "Amount" : "Gram",
              description: getHtml(descriptionController.text.trim()),
              gram: isAmountSelected ? null : double.tryParse(gramController.text.trim()),
              amount: !isAmountSelected ? null : double.tryParse(amountController.text.trim()),
            );

            final GetResponseModel? response = await _homeRepository.createGoldTransfer(data: data);

            Get.context?.loaderOverlay.hide();

            if (response?.isSuccess == true) {
              await showSuccessDialog(successMessage: response?.message);
              Get.back(result: true);
            }
          }
        },
      );
    }
  }

  void addRecipient() {
    Get.toNamed(Routes.CREATE_RECIPIENT)?.then((value) {
      if (value == true) init();
    });
  }
}
