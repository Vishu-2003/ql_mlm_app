import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../translation_controller.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';
import 'add_nominee_controller.dart';

class AddNomineeView extends StatelessWidget {
  const AddNomineeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNomineeController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.nomineeDetails),
          body: SizedBox.expand(
            child: SingleChildScrollView(
              physics: defaultScrollablePhysics,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    CText(
                      TranslationController.td
                          .youCanAppoint1NomineeInThisFormIfYouWishToAppointMoreThan1NomineePleaseVisitTheQMServiceCentre,
                      style: TextThemeX.text14,
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider(color: getOutlineColor, endIndent: 15, height: 60)),
                        CText(TranslationController.td.addNominee, style: TextThemeX.text16),
                        Expanded(child: Divider(color: getOutlineColor, endIndent: 15, height: 60)),
                      ],
                    ),
                    CTextField(
                      controller: controller.nameController,
                      labelText: TranslationController.td.name,
                      validator: AppValidator.emptyNullValidator,
                      helperText: TranslationController
                          .td.pleaseKeyInYourNomineesNameAsPerHisHerIdentificationDocuments,
                    ),
                    const SizedBox(height: 16),
                    CTextField(
                      validator: AppValidator.emailValidator,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: TranslationController.td.email,
                    ),
                    const SizedBox(height: 16),
                    CMobileTextField(
                      controller: controller.mobileController,
                      selectedCountryCode: controller.selectedCountryCode,
                      onCountryCodeChanged: controller.onCountryCodeChanged,
                    ),
                    const SizedBox(height: 16),
                    CPullDownButton(
                      items: NomineeIdentificationType.values
                          .map((e) => (data: e, item: e.value))
                          .toList(),
                      onChanged: controller.onIdentificationChanged,
                      hint: TranslationController.td.identificationType,
                      selectedItem: controller.selectedIdentificationType,
                    ),
                    const SizedBox(height: 16),
                    if (controller.selectedIdentificationType != null) ...[
                      CTextField(
                        labelText:
                            "${controller.selectedIdentificationType?.data.value ?? '-'} Number",
                        keyboardType: TextInputType.text,
                        validator: AppValidator.emptyNullValidator,
                        controller: controller.identificationNumberController,
                      ),
                      const SizedBox(height: 16),
                    ],
                    CPullDownButton(
                      items: NomineeRelationshipType.values
                          .map((e) => (data: e, item: e.value))
                          .toList(),
                      onChanged: controller.onRelationChanged,
                      hint: TranslationController.td.relationship,
                      selectedItem: controller.selectedRelationType,
                    ),
                    const SizedBox(height: 16),
                    CTextField(
                      enabled: false,
                      suffixText: "%",
                      labelText: "Share (%)",
                      textInputAction: TextInputAction.done,
                      controller: controller.shareController,
                      validator: AppValidator.numberValidator,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Divider(color: getOutlineColor, endIndent: 15, height: 60)),
                        CText(TranslationController.td.addWitness, style: TextThemeX.text16),
                        Expanded(child: Divider(color: getOutlineColor, endIndent: 15, height: 60)),
                      ],
                    ),
                    CTextField(
                      labelText: TranslationController.td.name,
                      validator: AppValidator.emptyNullValidator,
                      controller: controller.witnessNameController,
                    ),
                    const SizedBox(height: 16),
                    CTextField(
                      validator: AppValidator.emailValidator,
                      labelText: TranslationController.td.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.witnessEmailController,
                    ),
                    const SizedBox(height: 16),
                    CMobileTextField(
                      controller: controller.witnessMobileController,
                      selectedCountryCode: controller.selectedWintessCountryCode,
                      onCountryCodeChanged: controller.onWitnessCountryCodeChanged,
                    ),
                    const SizedBox(height: 16),
                    CPullDownButton(
                      items: NomineeIdentificationType.values
                          .map((e) => (data: e, item: e.value))
                          .toList(),
                      hint: TranslationController.td.identificationType,
                      onChanged: controller.onWitnessIdentificationChanged,
                      selectedItem: controller.selectedWitnessIdentificationType,
                    ),
                    const SizedBox(height: 16),
                    if (controller.selectedWitnessIdentificationType != null) ...[
                      CTextField(
                        keyboardType: TextInputType.text,
                        validator: AppValidator.emptyNullValidator,
                        controller: controller.witnessIdentificationNumberController,
                        labelText:
                            "${controller.selectedWitnessIdentificationType?.data.value ?? '-'} Number",
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 24),
                    CFlatButton(
                      onPressed: controller.onAddNominee,
                      text: TranslationController.td.submit,
                    ).defaultHorizontal,
                    SizedBox(height: context.bottomPadding),
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
