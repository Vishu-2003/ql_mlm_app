import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/utils/utils.dart';

class ScanQRController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    await requestCameraPermission();
  }

  void onQRScanned(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    GetMerchantDetailsModel? merchantDetails =
        await _homeRepository.validateMerchantQR(qrValue: barcodes.first.displayValue);

    if (merchantDetails != null) {
      Get.toNamed(Routes.MERHCANT_PAYMENT, arguments: merchantDetails.toJson());
    }
  }

  void onTapOnIcon() async {
    if (kReleaseMode) return;
    GetMerchantDetailsModel? merchantDetails =
        await _homeRepository.validateMerchantQR(qrValue: "31b34a68-95d0-46f8-8b9d-f182890cf4b9");

    if (merchantDetails != null) {
      Get.toNamed(Routes.MERHCANT_PAYMENT, arguments: merchantDetails.toJson());
    }
  }
}
