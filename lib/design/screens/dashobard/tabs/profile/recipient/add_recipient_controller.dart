import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class AddRecipientController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  GetProfileModel? memberDetails;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    accountNumberController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      Get.context?.loaderOverlay.show();

      GetResponseModel? response;
      response = await _homeRepository.addBeneficiary(
        beneficiery: PostBeneficiaryModel(
          beneficiaryName: nameController.text.trim(),
          beneficiaryEmail: emailController.text.trim(),
          beneficiaryMember: accountNumberController.text.trim(),
        ),
      );

      Get.context?.loaderOverlay.hide();

      if (response?.isSuccess == true) {
        await showSuccessDialog(successMessage: response?.message);
        Get.back(result: true);
      }
    }
  }

  Future<void> verifyMember() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      Get.context?.loaderOverlay.show();
      memberDetails = await _homeRepository.getMemberDetails(
        accountNumber: accountNumberController.text.trim(),
      );
      Get.context?.loaderOverlay.hide();

      nameController.text = memberDetails?.memberName ?? '';
      emailController.text = memberDetails?.email ?? '';
      update();
    }
  }

  void onRecipientNumberChanged(_) {
    memberDetails = null;
    nameController.clear();
    emailController.clear();
    update();
  }
}
