import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/design/components/components.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.editProfile),
          body: controller.isLoading
              ? defaultLoader()
              : SingleChildScrollView(
                  physics: defaultScrollablePhysics,
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        const _ProfilePicture(),
                        const SizedBox(height: 42),
                        CTextField(
                          keyboardType: TextInputType.text,
                          controller: controller.fullNameController,
                          validator: AppValidator.emptyNullValidator,
                          labelText: TranslationController.td.fullName,
                        ),
                        const SizedBox(height: 24),
                        CDatePickerField(
                          isRequired: false,
                          lastDate: DateTime.now(),
                          initialDate: controller.selectedDOB,
                          labelText: TranslationController.td.dateOfBirth,
                          onDateSelected: (date) {
                            controller.selectedDOB = date;
                          },
                        ),
                        const SizedBox(height: 24),
                        CTextField(
                          keyboardType: TextInputType.streetAddress,
                          controller: controller.addressLine1Controller,
                          labelText: TranslationController.td.addressLine1,
                        ),
                        const SizedBox(height: 24),
                        CTextField(
                          keyboardType: TextInputType.streetAddress,
                          controller: controller.addressLine2Controller,
                          labelText: TranslationController.td.addressLine2,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CTextField(
                                keyboardType: TextInputType.text,
                                controller: controller.occupationController,
                                labelText: TranslationController.td.occupation,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CSelectionSheetField(
                                isRequired: false,
                                sheetTitle: "Select Income Range", // TODO: i18n
                                controller: controller.incomeRangeController,
                                labelText: TranslationController.td.incomeRange,
                                items: controller.incomeRanges
                                    .map((range) => SelectionSheetItem(id: range, title: range))
                                    .toList(),
                                selectedItems: [
                                  SelectionSheetItem(
                                    id: controller.incomeRangeController.text,
                                    title: controller.incomeRangeController.text,
                                  ),
                                ],
                                onSelected: (item) {
                                  controller.incomeRangeController.text = item?.title ?? '';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CSelectionSheetField(
                                isRequired: false,
                                labelText: "Industry",
                                sheetTitle: "Select Industry", // TODO: i18n
                                controller: controller.industryController,
                                items: controller.industryTypes
                                    .map((industry) =>
                                        SelectionSheetItem(id: industry, title: industry))
                                    .toList(),
                                selectedItems: [
                                  SelectionSheetItem(
                                    id: controller.industryController.text,
                                    title: controller.industryController.text,
                                  )
                                ],
                                onSelected: (item) {
                                  controller.industryController.text = item?.title ?? '';
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CSelectionSheetField(
                                isRequired: false,
                                labelText: "Income Source",
                                sheetTitle: "Select Income Source", // TODO: i18n
                                controller: controller.incomeSourceController,
                                items: controller.sourceOfIncomes
                                    .map((source) => SelectionSheetItem(id: source, title: source))
                                    .toList(),
                                selectedItems: [
                                  SelectionSheetItem(
                                    id: controller.incomeSourceController.text,
                                    title: controller.incomeSourceController.text,
                                  ),
                                ],
                                onSelected: (item) {
                                  controller.incomeSourceController.text = item?.title ?? '';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CSelectionSheetField(
                                isRequired: false,
                                sheetTitle: "Select Country", // TODO: i18n
                                controller: controller.countryController,
                                labelText: TranslationController.td.country,
                                items: controller.countries
                                    .map((country) =>
                                        SelectionSheetItem(id: country, title: country))
                                    .toList(),
                                selectedItems: [
                                  SelectionSheetItem(
                                    id: controller.countryController.text,
                                    title: controller.countryController.text,
                                  )
                                ],
                                onSelected: (item) {
                                  controller.countryController.text = item?.title ?? '';
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CSelectionSheetField(
                                isRequired: false,
                                sheetTitle: "Select Nationality", // TODO: i18n
                                controller: controller.nationalityController,
                                labelText: TranslationController.td.nationality,
                                items: controller.countries
                                    .map((country) =>
                                        SelectionSheetItem(id: country, title: country))
                                    .toList(),
                                selectedItems: [
                                  SelectionSheetItem(
                                    id: controller.nationalityController.text,
                                    title: controller.nationalityController.text,
                                  ),
                                ],
                                onSelected: (item) {
                                  controller.nationalityController.text = item?.title ?? '';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CTextField(
                                keyboardType: TextInputType.streetAddress,
                                controller: controller.stateController,
                                labelText: TranslationController.td.state,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CTextField(
                                keyboardType: TextInputType.streetAddress,
                                controller: controller.cityController,
                                labelText: TranslationController.td.city,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CTextField(
                                keyboardType: TextInputType.number,
                                controller: controller.pincodeController,
                                labelText: TranslationController.td.postCode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CText(
                          TranslationController.td
                              .toProtectYourAccountAgainstUnauthorizedAccessWeStronglyRecommendThatYouEnableTwoFactorAuthenticationSoThatYourPasswordAloneIsNotEnoughToAccessYourAccount,
                          style: TextThemeX.text14,
                        ),
                        _TwoStepAuthRow(
                          value: true,
                          onChanged: (value) {},
                          text: TranslationController.td.googleAuthenticatorCode,
                        ),
                        _TwoStepAuthRow(
                          value: true,
                          onChanged: (value) {},
                          text: TranslationController.td.primaryPhoneNumber,
                        ),
                        _TwoStepAuthRow(
                          value: true,
                          onChanged: (value) {},
                          text: TranslationController.td.secondaryPhoneNumber,
                        ),
                        const SizedBox(height: 30),
                        CFlatButton(
                          onPressed: controller.updateProfile,
                          text: TranslationController.td.update,
                        ).defaultHorizontal,
                        SizedBox(height: context.bottomPadding),
                      ],
                    ),
                  ),
                ).defaultHorizontal,
        );
      },
    );
  }
}

class _TwoStepAuthRow extends StatelessWidget {
  final bool value;
  final String text;
  final Function(bool)? onChanged;
  const _TwoStepAuthRow({required this.value, required this.text, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CText(
          text,
          style: TextThemeX.text14.copyWith(
            color: getColorWhiteBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 40,
          child: Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: getPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (controller) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: getColorBlackWhite,
              backgroundImage: !isNullEmptyOrFalse(controller.selectedProfilePhotoPath)
                  ? selectFileImageProvider(controller.selectedProfilePhotoPath)
                  : selectAPIImageProvider(imageUrl: controller.getProfilePhotoPath),
            ),
            if (isNullEmptyOrFalse(controller.selectedProfilePhotoPath))
              Positioned(
                bottom: -15,
                child: CCoreButton(
                  onPressed: controller.pickDocument,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: getOutlineColor),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: selectIcon(AppIcons.camera, width: 18),
                  ),
                ),
              ),
            if (!isNullEmptyOrFalse(controller.selectedProfilePhotoPath))
              Positioned(
                bottom: -15,
                child: CCoreButton(
                  onPressed: controller.removeFile,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: getOutlineColor),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: selectIcon(AppIcons.close, width: 24),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
