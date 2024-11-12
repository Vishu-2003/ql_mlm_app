import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/auth_repository.dart';
import '/core/repositories/home_repository.dart';
import '/core/routes/app_pages.dart';
import '/design/components/components.dart';
import '/design/screens/init_controller.dart';
import '/design/screens/startup/login_controller.dart';
import '/design/screens/startup/verify_tac_view.dart';
import '/utils/utils.dart';

class RegisterMemberController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final List<String> genders = [];
  final List<String> currencies = [];
  final List<String> accountTypes = [];
  final List<String> countries = [];

  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GetCountryCodeModel selectedCountryCode = Get.find<InitController>().defaultCountryCode;

  PlatformFile? attachment;
  final TextEditingController referralNameOrCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (!isNullEmptyOrFalse(Get.parameters['referrer'])) {
      referralNameOrCodeController.text = Get.parameters['referrer']!;
    }
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    genders.assignAll(["Male", "Female"]);
    currencies.assignAll(await _homeRepository.getCurrencies());
    accountTypes.assignAll(await _homeRepository.getAccountTypes());
    isLoading = false;
    update();
  }

  void onAccountTypeChanged(({String data, String item}) selectedType) {
    accountTypeController.text = selectedType.data;
    attachment = null;
    update();
  }

  Future<void> pickFile() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (filePickerResult != null) {
      attachment = filePickerResult.files.first;
      update();
    }
  }

  void onCountryCodeChanged(GetCountryCodeModel value) {
    selectedCountryCode = value;
    update();
  }

  bool isTermsConditionsChecked = false;
  void onTermsConditionsChecked() {
    isTermsConditionsChecked = !isTermsConditionsChecked;
    update();
  }

  bool isPrivacyPolicyChecked = false;
  void onPrivacyPolicyChecked() {
    isPrivacyPolicyChecked = !isPrivacyPolicyChecked;
    update();
  }

  Future<void> onRegisterMember() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.context?.loaderOverlay.show();

      PostRegisterMemberModel member = PostRegisterMemberModel(
        attachment: attachment,
        email: emailController.text.trim(),
        currency: currencyController.text.trim(),
        memberName: fullNameController.text.trim(),
        accountType: accountTypeController.text.trim(),
        password: confirmPasswordController.text.trim(),
        referralNameOrCode: referralNameOrCodeController.text.trim(),
        mobile: formatMobileNumber(selectedCountryCode.code, mobileNumberController.text),
      );

      GetResponseModel? response = await _homeRepository.registerNewMember(member: member);

      Get.context?.loaderOverlay.hide();

      if (response?.isSuccess == true) {
        await showSuccessDialog(
          successMessage: response?.message ?? "",
          onButtonPressed: () => Get
            ..back()
            ..back(),
        );

        if (Get.previousRoute != Routes.DASHBOARD) {
          final bool? isValidated = await showAdaptiveDialog<bool>(
            context: Get.context!,
            barrierDismissible: false,
            barrierColor: getDialogBarrierColor,
            builder: (context) {
              return TACVerificationView(email: emailController.text.trim());
            },
          );

          // TODO: open for better solution
          LoginController loginController = Get.find<LoginController>();
          if (isValidated == true && accountTypeController.text.trim() == "Personal") {
            loginController.onLoginTypeChanged(LoginType.username);
            loginController.userNameController.text = emailController.text.trim();
            loginController.passwordController.text = confirmPasswordController.text.trim();
            // 100ms delay to let login screen change login type to username if mobile was selected
            await Future.delayed(const Duration(milliseconds: 100), () {
              loginController.signIn();
            });
          }
        }
      }
    }
  }

  Future<void> onGoogleSignUp() async {
    final UserCredential? crdential = await _authRepository.onGoogleSignIn();
    fullNameController.text = crdential?.user?.displayName ?? "";
    emailController.text = crdential?.user?.email ?? "";
  }

  Future<void> onFacebookSignUp() async {
    final UserCredential? credential = await _authRepository.onFacebookSignIn();
    fullNameController.text = credential?.user?.displayName ?? "";
    emailController.text = credential?.user?.email ?? "";
  }

  Future<void> onXSignIn() async {
    final UserCredential? credential = await _authRepository.onXSignIn();
    fullNameController.text = credential?.user?.displayName ?? "";
    emailController.text = credential?.user?.email ?? "";
  }

  Future<void> onAppleSignIn() async {
    final UserCredential? credential = await _authRepository.onAppleSignIn();
    fullNameController.text = credential?.user?.displayName ?? "";
    emailController.text = credential?.user?.email ?? "";
  }
}
