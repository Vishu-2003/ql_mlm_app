import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/models/models.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/home/home_controller.dart';

import '/core/repositories/home_repository.dart';

class NotificationsController extends GetxController {
  final HomeRepository homeRepository = Get.find<HomeRepository>();

  final List<GetNotificationModel> notificationsList = [];

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    notificationsList.assignAll(await homeRepository.getNotifications());
    isLoading = false;
    update();
    // We are not supposed to refresh screen
    final GetResponseModel<bool>? response = await homeRepository.markNotificationAsRead();

    if (response?.isSuccess == true) {
      // Locally updating the notification flag instead of fetching the whole dashboard details again
      Get.find<HomeController>().dashboardDetails =
          Get.find<HomeController>().dashboardDetails?.copyWith(openNotificationLog: false);
      Get.find<HomeController>().update();
    }
  }
}
