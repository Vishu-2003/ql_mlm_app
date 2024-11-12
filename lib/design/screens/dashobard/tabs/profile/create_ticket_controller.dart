import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';

class CreateTicketController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  final List<String> supportTypes = [];
  final List<String> severities = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController supportTypeController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  bool isLoading = false;
  Future<void> init() async {
    isLoading = true;
    update();
    final response = await Future.wait([
      _homeRepository.getTicketIssueTypes(),
      _homeRepository.getTicketSaverityList(),
    ]);
    supportTypes.assignAll(response[0]);
    severities.assignAll(response[1]);
    isLoading = false;
    update();
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      Get.context?.loaderOverlay.show();

      final GetResponseModel? response = await _homeRepository.createSupportTicket(
        supportTicket: PostSupportTicketModel(
          subject: subjectController.text.trim(),
          priority: severityController.text.trim(),
          issueType: supportTypeController.text.trim(),
          description: getHtml(descriptionController.text.trim()),
        ),
      );

      Get.context?.loaderOverlay.hide();

      if (response?.isSuccess == true) {
        await showSuccessDialog(successMessage: response?.message);
        Get.back(result: true);
      }
    }
  }
}
