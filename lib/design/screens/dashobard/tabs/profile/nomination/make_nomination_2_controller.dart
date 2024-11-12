import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';

class MakeNomination2Controller extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetMemberDetailsNomineeModel? memberDetails;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  void init() async {
    isLoading = true;
    update();
    memberDetails = await _homeRepository.getMemberDetailsBeforeNomination();
    isLoading = false;
    update();
  }
}
