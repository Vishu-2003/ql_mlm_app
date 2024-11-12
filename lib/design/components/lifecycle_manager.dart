import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/core/services/gs_services.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/home/home_controller.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  const LifeCycleManager({super.key, required this.child});

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  bool canOpen = false;
  bool isOpened = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        log('paused...');
        if (GSServices.getBiometricAuth) {
          if (!canOpen) {
            EasyDebounce.debounce('biometric_auth', const Duration(seconds: 10), () async {
              canOpen = true;
            });
          }
        }
      case AppLifecycleState.inactive:
        log('inactive...');
      case AppLifecycleState.detached:
        log('detached...');
      case AppLifecycleState.resumed:
        log('resume...');
        if (Get.isRegistered<HomeController>()) {
          // Refresh to check if any new notifications are available (to show red dot on the bell icon)
          HomeController homeController = Get.find<HomeController>();
          homeController.getDashboardDetails();
        }
        if (GSServices.getBiometricAuth) {
          EasyDebounce.cancel('biometric_auth');
          if (canOpen && !isOpened) {
            isOpened = true;

            final bool? isAuthenticated = await DesignUtils.doBiometricAuth();
            if (isAuthenticated == true) {
              canOpen = isOpened = false;
            }
          }
        }
      case AppLifecycleState.hidden:
        log('hidden...');
      default:
        log('default...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
