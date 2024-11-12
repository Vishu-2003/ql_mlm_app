import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'create_ticket_controller.dart';

class CreateTicketView extends GetWidget<CreateTicketController> {
  const CreateTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTicketController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(
            title: TranslationController.td.createTicket,
          ),
          body: controller.isLoading
              ? defaultLoader()
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: defaultScrollablePhysics,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          CPullDownButton<String>(
                            hint: '${TranslationController.td.supportType}*',
                            selectedItem: (
                              data: controller.supportTypeController.text,
                              item: controller.supportTypeController.text,
                            ),
                            items: controller.supportTypes
                                .map((type) => (item: type, data: type))
                                .toList(),
                            onChanged: (({String data, String item}) selectedType) {
                              controller.supportTypeController.text = selectedType.data;
                            },
                          ),
                          const SizedBox(height: 24),
                          CPullDownButton<String>(
                            hint: "${TranslationController.td.severity}*",
                            selectedItem: (
                              item: controller.severityController.text,
                              data: controller.severityController.text
                            ),
                            items: controller.severities
                                .map((gender) => (item: gender, data: gender))
                                .toList(),
                            onChanged: (({String data, String item}) selectedGender) {
                              controller.severityController.text = selectedGender.item;
                            },
                          ),
                          const SizedBox(height: 24),
                          CTextField(
                            keyboardType: TextInputType.text,
                            controller: controller.subjectController,
                            validator: AppValidator.emptyNullValidator,
                            labelText: '${TranslationController.td.subject}*',
                          ),
                          const SizedBox(height: 24),
                          CTextField(
                            maxLines: 5,
                            minLines: null,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            validator: AppValidator.emptyNullValidator,
                            controller: controller.descriptionController,
                            labelText: '${TranslationController.td.description}*',
                          ),
                          const SizedBox(height: 40),
                          CFlatButton(
                            onPressed: controller.onSubmit,
                            text: TranslationController.td.submit,
                          ).defaultHorizontal,
                        ],
                      ).defaultHorizontal,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
