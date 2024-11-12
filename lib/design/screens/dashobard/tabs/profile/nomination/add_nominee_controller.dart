import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qm_mlm_flutter/core/routes/app_pages.dart';
import 'package:qm_mlm_flutter/core/services/gs_services.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/init_controller.dart';
import '/utils/utils.dart';

class AddNomineeController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  ({NomineeRelationshipType data, String item})? selectedRelationType;
  ({NomineeIdentificationType data, String item})? selectedIdentificationType;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController shareController = TextEditingController(text: '100');
  TextEditingController identificationNumberController = TextEditingController();
  GetCountryCodeModel selectedCountryCode = Get.find<InitController>().defaultCountryCode;

  void onCountryCodeChanged(GetCountryCodeModel value) {
    selectedCountryCode = value;
    update();
  }

  void onIdentificationChanged(({NomineeIdentificationType data, String item}) value) {
    selectedIdentificationType = value;
    identificationNumberController.clear();
    update();
  }

  void onRelationChanged(({NomineeRelationshipType data, String item}) value) {
    selectedRelationType = value;
    update();
  }

  // Witness
  ({NomineeIdentificationType data, String item})? selectedWitnessIdentificationType;
  TextEditingController witnessNameController = TextEditingController();
  TextEditingController witnessIdentificationNumberController = TextEditingController();
  TextEditingController witnessEmailController = TextEditingController();
  TextEditingController witnessMobileController = TextEditingController();
  GetCountryCodeModel selectedWintessCountryCode = Get.find<InitController>().defaultCountryCode;

  void onWitnessCountryCodeChanged(GetCountryCodeModel value) {
    selectedWintessCountryCode = value;
    update();
  }

  void onWitnessIdentificationChanged(({NomineeIdentificationType data, String item}) value) {
    selectedWitnessIdentificationType = value;
    witnessIdentificationNumberController.clear();
    update();
  }

  void clearWitnessForm() {
    witnessNameController.clear();
    witnessIdentificationNumberController.clear();
    witnessEmailController.clear();
    witnessMobileController.clear();
    selectedWitnessIdentificationType = null;
    update();
  }

  void onAddNominee() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      await showConfirmationDialog(
        title: "Add Nominee",
        substitle: "Are you sure you want to add this nominee ?",
        onPositiveButtonPressed: () async {
          Get.back();
          Get.context?.loaderOverlay.show();

          PostAddNominationWitnessModel witness = PostAddNominationWitnessModel(
            email: witnessEmailController.text,
            witnessesName: witnessNameController.text,
            identificationType: selectedWitnessIdentificationType?.item,
            identificationNumber: witnessIdentificationNumberController.text,
            mobile:
                formatMobileNumber(selectedWintessCountryCode.code, witnessMobileController.text),
          );

          final PostAddNomineeModel nominee = PostAddNomineeModel(
            nomineeName: nameController.text,
            email: emailController.text.trim(),
            memberNominationWitnesses: [witness],
            relationship: selectedRelationType?.item,
            share: double.tryParse(shareController.text),
            identificationType: selectedIdentificationType?.item,
            identificationNumber: identificationNumberController.text,
            mobileNo: formatMobileNumber(selectedCountryCode.code, mobileController.text),
          );

          GetResponseModel<GetNomineeDetailsModel>? response =
              await _homeRepository.addNominee(nominee: nominee);

          Get.context?.loaderOverlay.hide();

          if (response?.isSuccess == true) {
            await showSuccessDialog(successMessage: response?.message);

            StreamController<ErrorAnimationType>? errorAnimationController =
                StreamController<ErrorAnimationType>();

            await showAdaptiveDialog<bool>(
              context: Get.context!,
              barrierDismissible: false,
              barrierColor: getDialogBarrierColor,
              builder: (context) {
                return OTPVerificationView(
                  onCompleted: (String code) async {
                    final GetResponseModel? verificationResponse =
                        await _homeRepository.verifyNomineeVerificationCode(
                      code: code,
                      email: GSServices.getUser!.user!,
                      nomineeId: response!.data!.name!,
                    );
                    if (verificationResponse?.isSuccess == true) {
                      Get.back(); // Close the dialog and continue the execution
                    } else {
                      errorAnimationController.add(ErrorAnimationType.shake);
                    }
                  },
                  errorAnimationController: errorAnimationController,
                );
              },
            );
            await errorAnimationController.close();
            Get.offAndToNamed(Routes.NOMINATION_DETAILS);
          }
        },
      );
    }
  }
}
