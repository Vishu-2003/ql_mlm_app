import 'package:get/get.dart';

import '/core/repositories/home_repository.dart';

class FAQController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final List<({String? question, String? answer})> faqs = [];

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    faqs.assignAll(await _homeRepository.getFAQs());
    isLoading = false;
    update();
  }
}
