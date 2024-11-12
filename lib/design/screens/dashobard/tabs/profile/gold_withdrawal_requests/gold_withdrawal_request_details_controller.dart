import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/models/gold_physical_withdrawal_model.dart';
import 'package:qm_mlm_flutter/core/repositories/home_repository.dart';

class GoldWithdrawalRequestDetailsController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  String? id;
  GetPhysicalGoldWithdrawalRequestModel? details;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters['id'] != null) {
      id = Get.parameters['id'];
    }
    init();
  }

  bool isLoading = false;
  void init() async {
    isLoading = true;
    update();
    details = await _homeRepository.getPhysicalWithdrawalOrder(id: id!);
    isLoading = false;
    update();
  }
}
