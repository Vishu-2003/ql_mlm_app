import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';

class ChangePasswordController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  RxBool obscureOldPassword = true.obs;
  RxBool obscureNewPassword = true.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Get.context?.loaderOverlay.show();

      final GetResponseModel? response = await _homeRepository.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      Get.context?.loaderOverlay.hide();

      if (response?.isSuccess == true) {
        await showSuccessDialog(successMessage: response?.message);
        Get.back();
      }
    }
  }
}
