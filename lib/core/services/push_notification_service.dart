import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:qm_mlm_flutter/design/screens/dashobard/tabs/home/home_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    enableLights: true,
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          debugPrint("onDidReceiveLocalNotification: $payload");
        },
      ),
    ),
    // onDidReceiveBackgroundNotificationResponse: (details) {
    //   debugPrint("onDidReceiveBackgroundNotificationResponse: $details");
    // },
    // onDidReceiveNotificationResponse: (details) {
    //   debugPrint("onDidReceiveNotificationResponse: $details");
    // },
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // Refresh dashboard to check if any new notifications are available (to show red dot on the bell icon)
  HomeController homeController = Get.find<HomeController>();
  homeController.getDashboardDetails();

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          priority: Priority.max,
          importance: Importance.max,
          icon: '@mipmap/ic_launcher',
          channelDescription: channel.description,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// Permissions

Future<void> requestNotificationPermissions() async {
  if ((await checkPermissions()).authorizationStatus == AuthorizationStatus.authorized) {
    return;
  }

  await FirebaseMessaging.instance.requestPermission(
    carPlay: true,
    announcement: true,
    criticalAlert: true,
  );
}

Future<NotificationSettings> checkPermissions() async {
  NotificationSettings notificationSettings =
      await FirebaseMessaging.instance.getNotificationSettings();
  debugPrint("authorizationStatus: ${notificationSettings.authorizationStatus.name}");
  return notificationSettings;
}
