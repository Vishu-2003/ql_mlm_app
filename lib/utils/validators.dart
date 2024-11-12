import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:qm_mlm_flutter/design/screens/translation_controller.dart';

class AppValidator {
  static String? emailValidator(String? value) {
    if (value?.trim().isEmpty ?? true) return "required!";

    if (value != null && !GetUtils.isEmail(value.trim())) {
      return TranslationController.td.invalidEmailAddress;
    }
    return null;
  }

  static String? emptyNullValidator(
    String? value, {
    String? errorMessage = "required!",
  }) {
    //TODO: Add Extra Validation If Needed
    if (value?.trim().isEmpty ?? true) return errorMessage;

    return null;
  }

  static String? numberValidator(
    String? value, {
    String? errorMessage = "Please enter valid number!",
  }) {
    if (value?.trim().isEmpty ?? true) {
      return "required!";
    } else if (double.tryParse(value!) == null || double.parse(value) <= 0) {
      return errorMessage;
    }
    return null;
  }
}
