import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/routes/app_pages.dart';
import '/core/services/gs_services.dart';
import '/core/services/push_notification_service.dart';
import '/design/components/components.dart';
import '/firebase_options.dart';
import '/utils/utils.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GSServices.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    setupFlutterNotifications();
    requestNotificationPermissions();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.changeThemeMode(ThemeMode.dark);
    return UnFocusWrapper(
      child: LifeCycleManager(
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayColor: getBgColor.withOpacity(0.4),
          overlayWidgetBuilder: (_) {
            return Center(child: SpinKitCircle(color: getPrimaryColor));
          },
          child: GetMaterialApp(
            title: 'QM',
            builder: (context, _) {
              return ResponsiveWrapper.builder(
                _,
                minWidth: 390,
                maxWidth: 1200,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(480, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                ],
              );
            },
            getPages: AppPages.routes,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.initialRoute,
            unknownRoute: AppPages.unknownRoute,
            initialBinding: BindingsX.initialBindings(),
          ),
        ),
      ),
    );
  }
}
