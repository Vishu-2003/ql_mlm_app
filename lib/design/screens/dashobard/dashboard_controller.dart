import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qm_mlm_flutter/core/repositories/auth_repository.dart';
import 'package:qm_mlm_flutter/core/routes/app_pages.dart';
import 'package:qm_mlm_flutter/design/components/components.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/screens/dashobard/tabs/history/history_controller.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';
import '/design/screens/dashobard/tabs/wallet/wallet_controller.dart';

class DashboardController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  PersistentTabController tabController = PersistentTabController(initialIndex: 0);

  GetProfileModel? profile;

  bool get isHomeControllerInitialized => Get.isRegistered<HomeController>();

  @override
  void onInit() {
    super.onInit();
    _homeRepository.sendUserDeviceInfo();
    init();
  }

  Future<void> init() async {
    profile = await _homeRepository.getUserProfile();
    update();
  }

  HistoryType _selectedHistoryType = HistoryType.gaeHistory;
  void navigateToHistory(HistoryType type) {
    _selectedHistoryType = type;
    tabController.index = 2;
    update();
    Get.find<HistoryController>().reRefreshPage(type: _selectedHistoryType);
  }

  void onTabChanged(int value) {
    tabController.index = value;
    update();
    if (tabController.index == 1 && Get.isRegistered<WalletController>()) {
      Get.find<WalletController>().init();
    } else if (tabController.index == 2 && Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().reRefreshPage();
    }
  }

  Future<void> logout() async {
    await showConfirmationDialog(
      onPositiveButtonPressed: () async {
        final bool loggedOut = await _authRepository.logout();
        if (loggedOut) Get.offAllNamed(Routes.LOGIN);
      },
      onNegativeButtonPressed: Get.back,
      title: TranslationController.td.logout,
      positiveButtonTitle: TranslationController.td.yesSure,
      substitle: TranslationController.td.areYouSureYouWantToLogout,
    );
  }
}
