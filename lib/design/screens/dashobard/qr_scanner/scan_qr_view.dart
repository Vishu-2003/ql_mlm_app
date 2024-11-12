import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '/design/components/components.dart';
import '/design/screens/dashobard/qr_scanner/scan_qr_controller.dart';
import '/utils/utils.dart';

class ScanQRView extends GetWidget<ScanQRController> {
  const ScanQRView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        title: "Scan Merchant QR Code",
        actions: [
          if (kDebugMode)
            CCoreButton(
              onPressed: controller.onTapOnIcon,
              child: const Icon(CupertinoIcons.qrcode_viewfinder),
            ).defaultHorizontal,
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: controller.onQRScanned,
        errorBuilder: (_, __, ___) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectIcon(AppIcons.cameraOff, width: 50)
                  .defaultContainer(shape: BoxShape.circle, hP: 20, vP: 20),
              const SizedBox(height: 20),
              CText(
                "Enable Camera Acess",
                style: TextThemeX.text20
                    .copyWith(color: getColorWhiteBlack, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              CText(
                "To make a faster payment please enable your camera permission to start scanning merchant QR code",
                textAlign: TextAlign.center,
                style: TextThemeX.text14.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const CFlatButton(
                text: "Enable Camera",
                width: 200,
                onPressed: openAppSettings,
              ),
              const SizedBox(height: 30),
            ],
          ).defaultHorizontal;
        },
      ),
    );
  }
}
