import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/home/kyc_view.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';

import '/core/models/models.dart';
import '/core/repositories/home_repository.dart';
import '/design/components/components.dart';
import '/utils/utils.dart';

class KYCController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

  int selectedStep = 1;
  int totalKycSteps = 3;

  String? kycId;
  GlobalKey<FormState> kycFormKey = GlobalKey<FormState>();
  List<String> documentTypes = ['Passport', 'Identity Card'];

  bool isCameraReady = false;
  CameraController? documentCameraController;
  CameraController? cameraController;
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    kycId = Get.arguments;
    selectedDocumentType = documentTypes.first;
  }

  @override
  void onClose() {
    videoKycTimer.dispose();
    cameraController?.dispose();
    videoPlayerController?.dispose();
    documentCameraController?.dispose();
    super.onClose();
  }

  FocusNode mobileOtpFocusNode = FocusNode();
  TextEditingController mobileOtpController = TextEditingController();
  StreamController<ErrorAnimationType> mobileOtpErrorController =
      StreamController<ErrorAnimationType>();

  GlobalKey<FormState> documentFormKey = GlobalKey<FormState>();

  XFile? kycVideoFile;
  late StopWatchTimer videoKycTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(10),
    onEnded: () async {
      Get.back();
      videoKycTimer.onResetTimer();
      kycVideoFile = await cameraController?.stopVideoRecording();
      videoPlayerController = VideoPlayerController.file(File(kycVideoFile!.path))
        ..initialize().then((_) => {update(), videoPlayerController?.play()});
    },
  );
  String? selectedFile;
  DateTime? selectedDOB;
  late String selectedDocumentType;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();

  void onNext() async {
    if (selectedStep == 1) {
      final bool isVerified = await verifyMobileOtp();
      if (!isVerified) {
        mobileOtpErrorController.add(ErrorAnimationType.shake);
        return;
      }
    } else if (selectedStep == 2) {
      bool isUploaded = onDocumentUpload();
      if (!isUploaded) return;
    } else if (selectedStep == 3) {
      bool isUploaded = onVideoUpload();
      if (!isUploaded) return;
      await submitKYC();
    }
    selectedStep = math.min(selectedStep + 1, totalKycSteps);
    update();
  }

  Future<bool> verifyMobileOtp() async {
    final GetResponseModel? response = await _homeRepository.validateKycMobileOTP(
      kycId: kycId,
      mobileOtp: mobileOtpController.text.trim(),
    );

    return response?.isSuccess == true;
  }

  void onDocumentTypeChanged(({String data, String item}) selectedGender) {
    selectedDocumentType = selectedGender.item;
    update();
  }

  Future<void> pickImage() async {
    final List<CameraDescription> cameras = await availableCameras();
    documentCameraController =
        CameraController(cameras[0], ResolutionPreset.veryHigh, enableAudio: false);
    await documentCameraController?.initialize();
    await showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return const DocumentCameraPreview();
      },
    );
  }

  Future<void> removeFile() async {
    selectedFile = null;
    update();
  }

  bool onDocumentUpload() {
    if (documentFormKey.currentState?.validate() == true) {
      documentFormKey.currentState?.save();

      if (selectedFile == null) {
        "Please upload document".errorSnackbar();
        return false;
      }
      _initializeCameraForVideoSelfie();
      return true;
    }
    return false;
  }

  bool onVideoUpload() {
    if (kycVideoFile == null) {
      "Please capture video".errorSnackbar();
      return false;
    }
    return true;
  }

  Future<void> recordVideo() async {
    if (videoKycTimer.isRunning) return;

    await cameraController?.startVideoRecording();
    videoKycTimer.onStartTimer();
  }

  Future<void> removeVideo() async {
    kycVideoFile = null;
    update();
  }

  Future<void> submitKYC() async {
    Get.context?.loaderOverlay.show();
    final GetResponseModel? response = await _homeRepository.uploadKYC(
      kycDetails: PostKYCDetailsModel(
        kyc: kycId!,
        dob: selectedDOB!,
        document: selectedFile!,
        documentType: selectedDocumentType,
        nameAsPerDocument: nameController.text.trim(),
        documentNumber: documentNumberController.text.trim(),
      ),
    );

    Get.context?.loaderOverlay.hide();

    if (response?.isSuccess == true) {
      await showSuccessDialog(
        successMessage: response?.message,
        onButtonPressed: () {
          Get
            ..back()
            ..back(result: true);
        },
      );
    }
  }

  Future<void> _initializeCameraForVideoSelfie() async {
    final List<CameraDescription> cameras = await availableCameras();
    final CameraDescription firstCamera = cameras[1];

    cameraController = CameraController(firstCamera, ResolutionPreset.medium, enableAudio: false);
    cameraController?.initialize().then((_) async {
      await _setZoomLevel(2);
      isCameraReady = true;
      update();
    });
  }

  Future<void> _setZoomLevel(double zoomLevel) async {
    if (cameraController!.value.isInitialized) {
      final double maxZoom = await cameraController!.getMaxZoomLevel();
      final double minZoom = await cameraController!.getMinZoomLevel();

      // Ensure zoomLevel is within the valid range
      zoomLevel = zoomLevel.clamp(minZoom, maxZoom);

      await cameraController!.setZoomLevel(zoomLevel);
    }
  }
}
