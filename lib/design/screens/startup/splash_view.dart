import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '/core/routes/app_pages.dart';
import '/core/services/gs_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      FlutterNativeSplash.remove();
      if (GSServices.getUser != null) {
        if (GSServices.getUser?.tacVerified == false) {
          await GSServices.clearLocalStorage();
          Get.offAllNamed(Routes.LOGIN);
          return;
        }
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
