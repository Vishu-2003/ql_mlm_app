import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';

class WalletController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetWalletModel? walletDetails;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool get isKYCVerified => Get.find<HomeController>().dashboardDetails?.kycStatus == "Verified";

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    await getWalletDetails();
    isLoading = false;
    update();
  }

  Future<void> getWalletDetails() async {
    walletDetails = await _homeRepository.getWalletDetails();
    update();
  }

  Future<void> onPayoutSettingsUpdated() async {
    Get.context?.loaderOverlay.show();

    final GetResponseModel? response =
        await _homeRepository.updatePayoutSettings(payoutSettings: walletDetails?.payoutSettings);

    Get.context?.loaderOverlay.hide();

    if (response?.isSuccess == true) {
      showSuccessDialog(successMessage: response?.message);
      init();
    }
  }
}
