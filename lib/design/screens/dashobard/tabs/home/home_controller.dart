import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/history/history_controller.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/core/services/biometric_service.dart';
import '/core/services/gs_services.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/dashboard_controller.dart';
import '/utils/utils.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final DashboardController _dashboardController = Get.find<DashboardController>();

  bool isLoading = false;
  List<GetItemModel> items = [];
  GetProfileModel? profileDetails;
  GetDashboardModel? dashboardDetails;
  ({String? name, String? customLocale, String? symbol})? currencyDetails;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
    Get.put<HistoryController>(HistoryController());
    if (GSServices.getBiometricAuth) DesignUtils.doBiometricAuth();
    if (!GSServices.getIsPromptedToEnableBiometric) {
      GSServices.setIsPromptedToEnableBiometric(isPrompted: true);
      showConfirmationDialog(
        positiveButtonTitle: "Enable",
        title: "Enable Biometric Authentication",
        substitle:
            "Easily log in with your fingerprint or face for added security and convenience.",
        onPositiveButtonPressed: () async {
          Get.back();
          final bool authenticated = await BiometricService.authenticate();
          if (authenticated) {
            await GSServices.setBiometricAuth(isEnabled: true);
          } else {
            await GSServices.setBiometricAuth(isEnabled: false);
          }
          if (GSServices.getBiometricAuth) {
            showSuccessDialog(successMessage: "Biometric Authentication Enabled");
          }
        },
      );
    }
  }

  bool get isKYCVerified => dashboardDetails?.kycStatus == "Verified";

  Future<void> init() async {
    isLoading = true;
    update();
    List response = await Future.wait([
      _homeRepository.getUserProfile(),
      _homeRepository.getDashboardDetails(),
      _homeRepository.getItemList(),
      _dashboardController.init(),
    ]);
    profileDetails = response[0];
    dashboardDetails = response[1];
    items = response[2];
    currencyDetails = response[3];
    isLoading = false;
    update();
  }

  Future<void> getDashboardDetails() async {
    dashboardDetails = await _homeRepository.getDashboardDetails();
    update();
  }

  Future<void> onStartKYC() async {
    PermissionStatus status = await requestCameraPermission();
    if (status.isDenied || status.isPermanentlyDenied) {
      "Camera permission is required to start KYC process".errorSnackbar();
      return;
    }
    await showConfirmationDialog(
      title: "Start Your KYC Process",
      positiveButtonTitle: "Continue",
      substitle: "Click continue to proceed",
      onPositiveButtonPressed: () async {
        final GetResponseModel<String>? response = await _homeRepository.startKYC();
        Get
          ..back()
          ..toNamed(Routes.KYC, arguments: response?.data)?.then((value) {
            if (value == true) init();
          });
      },
    );
  }
}
