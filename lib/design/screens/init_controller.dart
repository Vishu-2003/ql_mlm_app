import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';

class InitController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  List<GetCountryCodeModel> countryCodes = <GetCountryCodeModel>[];

  GetCountryCodeModel defaultCountryCode = GetCountryCodeModel(code: "+60", country: "Malaysia");

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    countryCodes = await _homeRepository.getCountryCodes();
    if (countryCodes.isNotEmpty) {
      defaultCountryCode = countryCodes[0];
    }
    update();
  }
}
