import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/screens/dashobard/tabs/home/home_controller.dart';

class SelectTradeController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetItemModel? item;
  List<GetGoldContractModel> goldContracts = <GetGoldContractModel>[];
  List<GetGoldContractModel> selectedGoldContracts = <GetGoldContractModel>[];
  String? get getGoldPrice => _homeController.dashboardDetails?.goldPrice;

  @override
  void onInit() {
    super.onInit();
    item = GetItemModel.fromJson(Get.arguments['item']);
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    goldContracts = await _homeRepository.getGoldContracts(item: item?.name);
    isLoading = false;
    update();
  }

  void onGoldContractSelected(GetGoldContractModel goldContract) {
    if (selectedGoldContracts.contains(goldContract)) {
      selectedGoldContracts.remove(goldContract);
    } else {
      selectedGoldContracts.add(goldContract);
    }
    update();
  }

  Future<void> onNext() async {
    if (contractAutoTradeFormKey.currentState?.validate() == true) {
      Get.toNamed(
        Routes.SELL_GOLD,
        arguments: {
          'item': item?.toJson(),
          'auto_trade': autoTradeContract,
          'gold_contracts': selectedGoldContracts.map((e) => e.toJson()).toList(),
          'auto_trade_rate': autoTradeContract ? autoTradeContractRateController.text : null,
        },
      );
    }
  }

  bool autoTradeContract = false;

  void onAutoTradeContractChanged(bool value) {
    autoTradeContract = value;
    if (!autoTradeContract) {
      autoTradeContractRateController.clear();
    }
    update();
  }

  GlobalKey<FormState> contractAutoTradeFormKey = GlobalKey<FormState>();
  TextEditingController autoTradeContractRateController = TextEditingController();
}
