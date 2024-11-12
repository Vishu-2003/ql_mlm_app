import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/design/screens/dashobard/dashboard_controller.dart';
import '/utils/utils.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final ProfileController _profileController = Get.find<ProfileController>();

  String? get getProfilePhotoPath => _profileController.profileDetails?.profilePhoto;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> countries = [];
  final List<String> incomeRanges = [];
  final List<String> industryTypes = [];
  final List<String> sourceOfIncomes = [];

  String? selectedProfilePhotoPath;
  final TextEditingController fullNameController = TextEditingController();
  DateTime? selectedDOB = DateTime.now();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController incomeRangeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController incomeSourceController = TextEditingController();
  bool is2FAEnabled = false;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    final List response = await Future.wait([
      _homeRepository.getCountries(),
      _homeRepository.getIndustryTypeList(),
      _homeRepository.getIncomeRangeList(),
      _homeRepository.getSourceOfIncomeList(),
    ]);
    countries.assignAll(response[0]);
    industryTypes.assignAll(response[1]);
    incomeRanges.assignAll(response[2]);
    sourceOfIncomes.assignAll(response[3]);
    fullNameController.text = _profileController.profileDetails?.memberName ?? '';
    selectedDOB = _profileController.profileDetails?.dateOfBirth?.convertDefaultDateTime;
    addressLine1Controller.text = _profileController.profileDetails?.addressLine1 ?? '';
    addressLine2Controller.text = _profileController.profileDetails?.addressLine2 ?? '';
    occupationController.text = _profileController.profileDetails?.occupation ?? '';
    incomeRangeController.text = _profileController.profileDetails?.incomeRange ?? '';
    industryController.text = _profileController.profileDetails?.industryType ?? '';
    incomeSourceController.text = _profileController.profileDetails?.sourceOfIncome ?? '';
    countryController.text = _profileController.profileDetails?.country ?? '';
    nationalityController.text = _profileController.profileDetails?.nationality ?? '';
    stateController.text = _profileController.profileDetails?.state ?? '';
    cityController.text = _profileController.profileDetails?.city ?? '';
    pincodeController.text = _profileController.profileDetails?.pincode ?? '';
    is2FAEnabled = _profileController.profileDetails?.twoFactorAuthentication ?? false;
    isLoading = false;
    update();
  }

  void on2FAChanged(bool value) {
    is2FAEnabled = value;
    update();
  }

  Future<void> updateProfile() async {
    try {
      Get.context?.loaderOverlay.show();

      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        if (!isNullEmptyOrFalse(selectedProfilePhotoPath)) {
          await _homeRepository.updateProfilePhoto(path: selectedProfilePhotoPath!);
          // Refresh to update profile photo in dashboard
          Get.find<DashboardController>().init();
        }

        UpdateProfileModel updatedProfile = UpdateProfileModel(
          name: _profileController.profileDetails?.name ?? '',
          memberName: fullNameController.text.trim(),
          dateOfBirth: selectedDOB,
          addressLine1: addressLine1Controller.text.trim(),
          addressLine2: addressLine2Controller.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          country: countryController.text.trim(),
          pincode: pincodeController.text.trim(),
          nationality: nationalityController.text.trim(),
          twoFactorAuthentication: is2FAEnabled,
          incomeRange: incomeRangeController.text.trim(),
          occupation: occupationController.text.trim(),
          industryType: industryController.text.trim(),
          sourceOfIncome: incomeSourceController.text.trim(),
        );

        GetResponseModel? response = await _homeRepository.updateProfile(
          updatedProfile: updatedProfile,
        );

        Get.context?.loaderOverlay.hide();

        if (response?.isSuccess == true) {
          await showSuccessDialog(
            successMessage: response?.message,
            onButtonPressed: Get.back,
          );
          Get.back(result: true);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }

  Future<void> pickDocument() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePickerResult != null) {
      selectedProfilePhotoPath = filePickerResult.files.first.path;
      update();
    }
  }

  Future<void> removeFile() async {
    selectedProfilePhotoPath = null;
    update();
  }
}
