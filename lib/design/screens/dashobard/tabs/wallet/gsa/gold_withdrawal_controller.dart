import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';

class GoldWithdrawalController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  int totalSteps = 2;
  int _currentStep = 1;

  int get currentStep => _currentStep;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<({GetGoldPhysicalWithdrawalItemModel item, int qty})> items = [];

  List<String> countryList = [];
  List<String> regionList = [];
  List<GetGoldPhysicalWithdrawalBranchModel> branchList = [];
  GetGoldPhysicalWithdrawalDataModel? getGoldPhysicalWithdrawalData;
  GetGoldPhysicalWithdrawalDeliveryDetailsModel? deliveryDetails;

  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  GetGoldPhysicalWithdrawalBranchModel? selectedBranch;
  TextEditingController deliveryAddressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  void init() async {
    isLoading = true;
    update();
    getGoldPhysicalWithdrawalData = await _homeRepository.getGoldPhysicalWithdrawalData();
    countryList = await _homeRepository.getGoldPhysicalWithdrawalCountryList();
    deliveryDetails = await _homeRepository.getGoldPhysicalWithdrawalDeliveryDetails();
    deliveryAddressController.text = deliveryDetails?.address ?? "";
    isLoading = false;
    update();
  }

  void gotoStep1() {
    _currentStep = 1;
    update();
  }

  void gotoStep2() async {
    if (formKey.currentState?.validate() == true) {
      _currentStep = 2;
      update();
      Get.context?.loaderOverlay.show();
      this.items.clear();
      List<GetGoldPhysicalWithdrawalItemModel> items =
          await _homeRepository.getGoldPhysicalWithdrawalItems(branch: selectedBranch?.name);
      this.items = items.map((e) => (item: e, qty: 0)).toList();
      update();
      Get.context?.loaderOverlay.hide();
    }
  }

  void onCountryChanged(({String data, String item}) value) async {
    Get.context?.loaderOverlay.show();
    countryController.text = value.data;
    regionList.clear();
    regionController.clear();
    branchList.clear();
    selectedBranch = null;
    items.clear();
    regionList = await _homeRepository.getGoldPhysicalWithdrawalRegionList(country: value.data);
    update();
    Get.context?.loaderOverlay.hide();
  }

  void onRegionChanged(({String data, String item}) value) async {
    Get.context?.loaderOverlay.show();
    regionController.text = value.data;
    branchList.clear();
    items.clear();
    selectedBranch = null;
    branchList = await _homeRepository.getGoldPhysicalWithdrawalBranchList(region: value.data);
    update();
    Get.context?.loaderOverlay.hide();
  }

  void onBranchChanged(({GetGoldPhysicalWithdrawalBranchModel data, String item}) value) async {
    selectedBranch = value.data;
    update();
  }

  void onQtyIncreased(({GetGoldPhysicalWithdrawalItemModel item, int qty}) value) {
    double cartGoldWeight = calculateSelectedGoldWeight();
    if (cartGoldWeight + (value.item.goldWeight ?? 0) >
        (getGoldPhysicalWithdrawalData?.balanceBeforeRequestInValue ?? 0)) {
      "You don't have enough gold".errorSnackbar();
      return;
    }
    items[items.indexOf(value)] = (item: value.item, qty: value.qty + 1);
    update();
  }

  void onQtyDecreased(({GetGoldPhysicalWithdrawalItemModel item, int qty}) value) {
    items[items.indexOf(value)] = (item: value.item, qty: value.qty - 1);
    update();
  }

  double calculateSelectedGoldWeight() {
    double total = 0;
    for (var element in items) {
      total += (element.item.goldWeight ?? 0) * element.qty;
    }
    return total;
  }

  Future<void> onPlaceOrder() async {
    if (calculateSelectedGoldWeight() <= 0) {
      "Please select at least one item".errorSnackbar();
      return;
    }
    await showConfirmationDialog(
      title: "Place Order",
      substitle:
          'I agreed and confirmed that the Shipping Address given herein is my current address. I authorize Quantum Metal Sdn Bhd ("QM") to proceed with the physical delivery to me. I undertake that QM shall not be responsible for any damages/losses/claims directly or indirectly due to any invalid and/or incomplete Shipping Address given above.',
      positiveButtonTitle: "Agreed & Confirm",
      onPositiveButtonPressed: () async {
        Get.back();
        Get.context?.loaderOverlay.show();
        final PostGoldPhysicalWithdrawalOrderModel order = PostGoldPhysicalWithdrawalOrderModel(
          country: countryController.text,
          region: regionController.text,
          branch: selectedBranch?.name ?? "",
          branchAddress:
              selectedBranch?.isDelivery == false ? selectedBranch?.branchAddress ?? "" : null,
          deliveryAddress:
              selectedBranch?.isDelivery == true ? deliveryAddressController.text.trim() : null,
          mobileNo: deliveryDetails?.mobile ?? "",
          items: items
              .map((e) => PostGoldPhysicalWithdrawalOrderItemModel(
                    qty: e.qty,
                    goldPhysicalWithdrawalItem: e.item.itemCode,
                  ))
              .toList()
              .where((element) => (element.qty ?? 0) > 0)
              .toList(),
        );

        final GetResponseModel? response =
            await _homeRepository.createGoldPhysicalWithdrawalOrder(order: order);

        Get.context?.loaderOverlay.hide();

        if (response?.isSuccess == true) {
          await showSuccessDialog(successMessage: response?.message);
          Get.back(result: true);
        }
      },
    );
  }
}
