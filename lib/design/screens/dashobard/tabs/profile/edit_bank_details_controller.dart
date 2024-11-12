import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import 'profile_controller.dart';

class EditBankDetailsController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final ProfileController _profileController = Get.find<ProfileController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    bankNameController.text = _profileController.profileDetails?.bankName ?? '';
    accountHolderNameController.text =
        _profileController.profileDetails?.bankAccountHolderName ?? '';
    accountNumberController.text = _profileController.profileDetails?.accountNumber ?? '';
    ifscCodeController.text = _profileController.profileDetails?.ifscCode ?? '';
  }

  Future<void> updateBankDetails() async {
    if (formKey.currentState!.validate()) {
      Get.context?.loaderOverlay.show();

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();
        UpdateBankModel updatedBankDetails = UpdateBankModel(
          bankName: bankNameController.text.trim(),
          ifscCode: ifscCodeController.text.trim(),
          accountNumber: accountNumberController.text.trim(),
          name: _profileController.profileDetails?.name ?? '',
          bankAccountHolderName: accountHolderNameController.text.trim(),
        );

        GetResponseModel? response = await _homeRepository.updateBankDetails(
          updatedBankDetails: updatedBankDetails,
        );

        Get.context?.loaderOverlay.hide();

        if (response?.isSuccess == true) {
          await showSuccessDialog(successMessage: response?.message);
          Get.back(result: true);
        }
      }
    }
  }
}
