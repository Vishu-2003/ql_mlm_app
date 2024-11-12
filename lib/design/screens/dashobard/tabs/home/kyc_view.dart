import 'package:camera/camera.dart';
import 'package:custom_ratio_camera/custom_ratio_camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/tabs/home/kyc_controller.dart';
import '/design/screens/translation_controller.dart';
import '/utils/utils.dart';

class KYCView extends StatelessWidget {
  const KYCView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return Scaffold(
          appBar: CAppBar(title: TranslationController.td.kYCVerification),
          body: Form(
            key: controller.kycFormKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const _FormStepNavigator(),
                const SizedBox(height: 16),
                Expanded(
                  child: controller.selectedStep == 1
                      ? const _Step1()
                      : controller.selectedStep == 2
                          ? const _Step2()
                          : const _Step3(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const _BottomBarButtons(),
        );
      },
    );
  }
}

class _BottomBarButtons extends StatelessWidget {
  const _BottomBarButtons();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return CFlatButton(
          borderRadius: 12,
          bgColor: getPrimaryColor,
          onPressed: controller.onNext,
          textColor: getColorWhiteBlack,
          text: controller.selectedStep == controller.totalKycSteps
              ? TranslationController.td.subject
              : TranslationController.td.$continue,
        ).bottomNavBarButton(context);
      },
    );
  }
}

class _Step1 extends StatelessWidget {
  const _Step1();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return SingleChildScrollView(
          physics: defaultScrollablePhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CText(
                TranslationController.td.mobileOTP,
                style: TextThemeX.text16.copyWith(color: getPrimaryTextColor),
              ),
              const SizedBox(height: 10),
              PinCodeTextField(
                length: 6,
                cursorWidth: 1,
                cursorHeight: 20,
                hintCharacter: '-',
                appContext: context,
                keyboardType: TextInputType.number,
                focusNode: controller.mobileOtpFocusNode,
                animationType: AnimationType.scale,
                textStyle: TextThemeX.text20.copyWith(
                  color: getPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
                pinTheme: PinTheme(
                  borderWidth: 1,
                  fieldWidth: 50,
                  fieldHeight: 50,
                  activeColor: getPrimaryColor,
                  shape: PinCodeFieldShape.box,
                  selectedColor: getPrimaryColor,
                  inactiveColor: getOutlineColor,
                  borderRadius: BorderRadius.circular(10),
                  errorBorderColor: lightRed.withOpacity(.5),
                ),
                controller: controller.mobileOtpController,
                errorAnimationController: controller.mobileOtpErrorController,
              ),
            ],
          ),
        );
      },
    ).defaultHorizontal;
  }
}

class _Step2 extends StatelessWidget {
  const _Step2();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return SingleChildScrollView(
          physics: defaultScrollablePhysics,
          child: Form(
            key: controller.documentFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CPullDownButton<String>(
                  hint: TranslationController.td.documentType,
                  selectedItem: (
                    item: controller.selectedDocumentType,
                    data: controller.selectedDocumentType
                  ),
                  onChanged: controller.onDocumentTypeChanged,
                  items: controller.documentTypes.map((type) => (item: type, data: type)).toList(),
                ),
                const SizedBox(height: 15),
                Center(
                  child: CCoreButton(
                    onPressed: controller.pickImage,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DottedBorder(
                      strokeWidth: 1.5,
                      color: getOutlineColor,
                      dashPattern: const [8, 6],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      child: Container(
                        width: 300,
                        height: 189,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            opacity: 0.16,
                            fit: BoxFit.cover,
                            image: controller.selectedFile != null
                                ? selectFileImageProvider(controller.selectedFile)
                                : selectAssetImageProvider(AppImages.dummyDocument),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (controller.selectedFile != null)
                              selectIcon(
                                setldImageIcon(AppIcons.close),
                                width: 30,
                                onPressed: controller.removeFile,
                              ),
                            if (controller.selectedFile == null) ...[
                              Icon(CupertinoIcons.arrow_up_doc_fill, size: 30, color: getGrey1),
                              const SizedBox(height: 10),
                              Center(
                                child: CText(
                                  "${TranslationController.td.upload} ${controller.selectedDocumentType}",
                                  style: TextThemeX.text16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CTextField(
                  keyboardType: TextInputType.name,
                  controller: controller.nameController,
                  validator: AppValidator.emptyNullValidator,
                  labelText: TranslationController.td.legalName,
                ),
                const SizedBox(height: 16),
                CTextField(
                  keyboardType: TextInputType.text,
                  validator: AppValidator.emptyNullValidator,
                  controller: controller.documentNumberController,
                  labelText: TranslationController.td.documentNumber,
                ),
                const SizedBox(height: 16),
                CDatePickerField(
                  lastDate: DateTime.now(),
                  initialDate: controller.selectedDOB,
                  labelText: TranslationController.td.dateOfBirth,
                  onDateSelected: (date) {
                    controller.selectedDOB = date;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    ).defaultHorizontal;
  }
}

class _Step3 extends StatelessWidget {
  const _Step3();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return SingleChildScrollView(
          physics: defaultScrollablePhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              controller.isCameraReady ? const _CapturePhoto() : defaultLoader(size: 25),
              const SizedBox(height: 30),
              Row(
                children: [
                  CText(
                    TranslationController.td.takeAVideo,
                    style: TextThemeX.text24.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                  selectIcon(AppIcons.arrow, width: 35).paddingOnly(bottom: 20),
                ],
              ),
              const SizedBox(height: 8),
              CText(
                TranslationController.td.weWillCompareItWithYourDocument,
                style: TextThemeX.text16.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selectIcon(AppIcons.face).paddingOnly(right: 10),
                  Expanded(
                    child: CText(
                      TranslationController.td
                          .pleasePositionYourselfInFrontOfTheCameraSlowlyTurnYourHeadToTheLeftAndThenToTheRightWithin10SecondsEnsureYourFaceIsWellLitAndCenteredThankYou,
                      style: TextThemeX.text16.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  selectIcon(AppIcons.goggles).paddingOnly(right: 10),
                  Expanded(
                    child: CText(
                      TranslationController.td.removeYourGlassesIfNecessary,
                      style: TextThemeX.text16.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).defaultHorizontal;
  }
}

class _CapturePhoto extends StatelessWidget {
  const _CapturePhoto();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  await showAdaptiveDialog(
                    context: context,
                    barrierColor: getDialogBarrierColor,
                    builder: (context) => Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CCoreButton(
                              onPressed: Get.back,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: CText(
                                  TranslationController.td.cancel,
                                  style: TextThemeX.text16.copyWith(color: lPrimaryColor),
                                ),
                              ),
                            ),
                            selectImage(AppGifs.videoKyc, width: 100),
                            Align(
                              alignment: Alignment.center,
                              child: DottedBorder(
                                strokeWidth: 2,
                                color: lPrimaryColor,
                                dashPattern: const [8, 6],
                                borderType: BorderType.Oval,
                                radius: const Radius.circular(50),
                                child: ClipOval(
                                  child: CameraPreview(controller.cameraController!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            StreamBuilder<int>(
                              stream: controller.videoKycTimer.rawTime,
                              builder: (context, snapshot) {
                                final String displayTime = StopWatchTimer.getDisplayTime(
                                  snapshot.data ?? 0,
                                  hours: false,
                                  minute: false,
                                  milliSecond: false,
                                );
                                return CFlatButton(
                                  text: controller.videoKycTimer.isRunning
                                      ? displayTime
                                      : TranslationController.td.record,
                                  onPressed: controller.recordVideo,
                                ).defaultHorizontal;
                              },
                            ),
                          ],
                        ).defaultContainer(),
                      ),
                    ),
                  );
                },
                child: DottedBorder(
                  strokeWidth: 2,
                  color: getGrey1,
                  dashPattern: const [8, 6],
                  borderType: BorderType.Circle,
                  radius: const Radius.circular(50),
                  child: CircleAvatar(
                    backgroundColor: getColorBlackWhite,
                    radius: controller.kycVideoFile != null ? 80 : 45,
                    child:
                        controller.kycVideoFile != null && controller.videoPlayerController != null
                            ? ClipOval(child: VideoPlayer(controller.videoPlayerController!))
                            : Icon(CupertinoIcons.videocam_fill, size: 30, color: getGrey1),
                  ),
                ),
              ),
            ),
            if (!isNullEmptyOrFalse(controller.kycVideoFile))
              Positioned(
                bottom: -15,
                child: CCoreButton(
                  onPressed: controller.removeVideo,
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

class _FormStepNavigator extends StatelessWidget {
  const _FormStepNavigator();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KYCController>(
      builder: (controller) {
        return SizedBox(
          height: 30,
          width: 50 * controller.totalKycSteps.toDouble(),
          child: ListView.builder(
            physics: neverScrollablePhysics,
            scrollDirection: Axis.horizontal,
            itemCount: controller.totalKycSteps,
            itemBuilder: (context, index) {
              bool isLastStep = index == controller.totalKycSteps - 1;
              return Row(
                children: [
                  AnimatedContainer(
                    width: 28,
                    height: 28,
                    duration: 300.ms,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < controller.selectedStep ? getPrimaryColor : getOutlineColor,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextThemeX.text14.copyWith(color: getColorWhiteBlack),
                    ),
                  ),
                  if (!isLastStep)
                    AnimatedContainer(
                      width: 26,
                      height: 2,
                      duration: 300.ms,
                      color:
                          index < controller.selectedStep - 1 ? getPrimaryColor : getOutlineColor,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class DocumentCameraPreview extends GetWidget<KYCController> {
  const DocumentCameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isProcessing = false.obs;
    ({int dx, int dy, int h, int w}) cropData = (dx: 0, dy: 0, h: 0, w: 0);
    return Material(
      color: getColorBlackWhite,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomRatioCameraPreview(
            expectedRatio: 1.586,
            cameraController: controller.documentCameraController!,
            onCropData: (dx, dy, w, h) {
              cropData = (dx: dx, dy: dy, h: h, w: w);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: getColorBlackWhite,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ClipRRect(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: Get.back,
                        child: Text(
                          TranslationController.td.cancel,
                          style: TextThemeX.text16.copyWith(color: getColorWhiteBlack),
                        ).paddingOnly(left: 20),
                      ),
                    ),
                    Obx(
                      () => CCoreButton(
                        onPressed: isProcessing.isTrue
                            ? null
                            : () async {
                                try {
                                  isProcessing.value = true;
                                  final XFile? photo =
                                      await controller.documentCameraController?.takePicture();
                                  if (isNullEmptyOrFalse(photo?.path)) return;
                                  final String inputPath = photo!.path;
                                  final List<String> inputPathComponents = inputPath.split('/');
                                  final String inputFileName = inputPathComponents.last;
                                  final String inputFileNameWithoutExtension =
                                      inputFileName.split('.').first;
                                  final String inputExtension = inputFileName.split('.').last;
                                  final String outputFileName =
                                      'cropped_$inputFileNameWithoutExtension.$inputExtension';

                                  final String outputPath =
                                      '${inputPathComponents.sublist(0, inputPathComponents.length - 1).join('/')}/$outputFileName';
                                  await FFmpegKit.execute(
                                    '-i $inputPath -vf "crop=${cropData.w}:${cropData.h}:${cropData.dx}:${cropData.dy}" $outputPath',
                                  );
                                  controller.selectedFile = outputPath;
                                  Get.back();
                                  controller.update();
                                } catch (e) {
                                  debugPrint(e.toString());
                                } finally {
                                  isProcessing.value = false;
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: getColorWhiteBlack, width: 4),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle, size: 70, color: getColorWhiteBlack),
                              if (isProcessing.isTrue)
                                defaultLoader(color: getColorBlackWhite, size: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
