import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qm_mlm_flutter/core/models/models.dart';

import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/utils/utils.dart';

class DepositFundController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  List<({bool attachmentRequired, PaymentMode? mode})> paymentMethods = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ({({bool attachmentRequired, PaymentMode? mode}) data, String item})? selectedPaymentMethod;
  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (!isNullEmptyOrFalse(Get.parameters['amount'])) {
      amountController.text = Get.parameters['amount'] ?? '';
      if (Get.parameters['amount'] == '0.0') {
        amountController.clear();
      }
    }
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    paymentMethods.assignAll(await _homeRepository.getModeOfPayment());
    isLoading = false;
    update();
  }

  void onPaymentMethodSelected(
    ({
      String item,
      ({bool attachmentRequired, PaymentMode? mode}) data,
    }) selectedMethod,
  ) {
    selectedPaymentMethod = selectedMethod;
    update();
  }

  Future<void> onDeposit() async {
    if (formKey.currentState?.validate() ?? false) {
      await showConfirmationDialog(
        title: "Deposit Fund",
        onPositiveButtonPressed: () async {
          try {
            Get.back();
            Get.context?.loaderOverlay.show();
            await switch (selectedPaymentMethod?.data.mode) {
              PaymentMode.stripe => _payUsingStripe(),
              PaymentMode.directTransfer => _payUsingDirectTransfer(),
              _ => null,
            };
          } catch (e) {
            debugPrint(e.toString());
          } finally {
            Get.context?.loaderOverlay.hide();
          }
        },
        positiveButtonTitle: "Yes, Sure",
        onNegativeButtonPressed: Get.back,
        substitle: "Are you sure you want to deposit fund to your account?",
      );
    }
  }

  Future<void> _payUsingStripe() async {
    final ({String? clientSecret, String? depositDocId, String? id})? response =
        await _homeRepository.depositFund(
      amount: double.parse(amountController.text),
      paymentMethod: selectedPaymentMethod!.data.mode!.value,
    );

    if (!isNullEmptyOrFalse(response?.depositDocId)) {
      Stripe.publishableKey = Get.find<HomeController>().dashboardDetails!.settings!.stripeKey!;

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

      showSuccessDialog(
        title: "Transaction successful!",
        onButtonPressed: () => Get
          ..back()
          ..back(result: true),
        successMessage: "Your fund has been successfully deposited!",
      );
    } else {
      debugPrint("depositDocId: ${response?.depositDocId}");
    }
  }

  PlatformFile? attachment;
  Future<void> pickFile() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (filePickerResult != null) {
      attachment = filePickerResult.files.first;
      update();
    }
  }

  Future<void> _payUsingDirectTransfer() async {
    if (attachment == null) {
      "Please upload the attachment file".errorSnackbar();
      return;
    }

    final GetResponseModel? response = await _homeRepository.addMoneyWallet(
      amount: double.parse(amountController.text),
      file: attachment!,
      modeOfPayment: selectedPaymentMethod!.data.mode!,
    );
    if (response?.isSuccess == true) {
      showSuccessDialog(
        onButtonPressed: () => Get
          ..back()
          ..back(result: true),
        successMessage: response?.message,
      );
    }
  }
}
