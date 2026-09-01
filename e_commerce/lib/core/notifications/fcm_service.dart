import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ============================================================
/// BACKGROUND FCM HANDLER
/// ============================================================
/// This function MUST be top-level.
/// It can be called when the app is in background/terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // DO NOT show a local notification here if your Express server
  // sends an FCM "notification" payload.
  //
  // Android automatically displays notification messages
  // in the system notification tray when the app is backgrounded.
  //
  // You can use this handler for saving data/logging if needed.

  if (kDebugMode) {
    print('======================================');
  }
  if (kDebugMode) {
    print('BACKGROUND FCM MESSAGE');
  }
  if (kDebugMode) {
    print('Title: ${message.notification?.title}');
  }
  if (kDebugMode) {
    print('Body: ${message.notification?.body}');
  }
  if (kDebugMode) {
    print('Data: ${message.data}');
  }
  if (kDebugMode) {
    print('======================================');
  }
}

class FcmService {
  FcmService({this.onNotificationTap, this.onForegroundMessage});

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final void Function(Map<String, dynamic> data)? onNotificationTap;

  final void Function(Map<String, dynamic> data)? onForegroundMessage;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> init() async {
    if (kDebugMode) {
      print('======================================');
    }
    if (kDebugMode) {
      print('INITIALIZING FCM');
    }
    if (kDebugMode) {
      print('======================================');
    }

    // Skip FCM on web (push notifications not needed on web)
    if (kIsWeb) {
      if (kDebugMode) {
        print('FCM SKIPPED ON WEB');
      }
      return;
    }

    // ----------------------------------------------------------
    // REQUEST FIREBASE PERMISSION
    // ----------------------------------------------------------

    final permission = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('FCM AUTHORIZATION STATUS: ${permission.authorizationStatus}');
    }

    // ----------------------------------------------------------
    // ANDROID LOCAL NOTIFICATION INITIALIZATION
    // ----------------------------------------------------------

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // ----------------------------------------------------------
    // ANDROID 13+ NOTIFICATION PERMISSION
    // ----------------------------------------------------------

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.requestNotificationsPermission();
    }

    // ----------------------------------------------------------
    // CREATE ANDROID NOTIFICATION CHANNEL
    // ----------------------------------------------------------

    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      const channel = AndroidNotificationChannel(
        'order_updates',
        'Order Updates',
        description: 'Notifications about orders and other updates',
        importance: Importance.high,
      );

      await androidPlugin?.createNotificationChannel(channel);
    }

    // ----------------------------------------------------------
    // FOREGROUND MESSAGE
    // ----------------------------------------------------------

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('======================================');
      }
      if (kDebugMode) {
        print('FOREGROUND FCM MESSAGE');
      }
      if (kDebugMode) {
        print('TITLE: ${message.notification?.title}');
      }
      if (kDebugMode) {
        print('BODY: ${message.notification?.body}');
      }
      if (kDebugMode) {
        print('DATA: ${message.data}');
      }
      if (kDebugMode) {
        print('======================================');
      }

      onForegroundMessage?.call(message.data);

      _showLocalNotification(message);
    });

    // ----------------------------------------------------------
    // APP OPENED FROM BACKGROUND BY TAPPING NOTIFICATION
    // ----------------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('======================================');
      }
      if (kDebugMode) {
        print('NOTIFICATION CLICKED - BACKGROUND');
      }
      if (kDebugMode) {
        print('DATA: ${message.data}');
      }
      if (kDebugMode) {
        print('======================================');
      }

      _showLocalNotification(message);

      onNotificationTap?.call(message.data);
    });

    // ----------------------------------------------------------
    // APP OPENED FROM TERMINATED STATE
    // ----------------------------------------------------------

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print('======================================');
      }
      if (kDebugMode) {
        print('NOTIFICATION CLICKED - TERMINATED');
      }
      if (kDebugMode) {
        print('DATA: ${initialMessage.data}');
      }
      if (kDebugMode) {
        print('======================================');
      }

      onNotificationTap?.call(initialMessage.data);
    }

    // ----------------------------------------------------------
    // TOKEN
    // ----------------------------------------------------------

    final token = await getToken();

    print('======================================');
    if (kDebugMode) {
      print('FCM TOKEN');
    }
    print(token);
    print('======================================');
  }

  // ============================================================
  // GET FCM TOKEN
  // ============================================================

  Future<String?> getToken() async {
    final token = await _messaging.getToken();

    print('======================================');
    print('FCM TOKEN: $token');
    print('======================================');

    return token;
  }

  // ============================================================
  // TOKEN REFRESH
  // ============================================================

  void onTokenRefresh(void Function(String token) callback) {
    _messaging.onTokenRefresh.listen((token) {
      print('FCM TOKEN REFRESHED: $token');
      callback(token);
    });
  }

  // ============================================================
  // SHOW FOREGROUND NOTIFICATION
  // ============================================================

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Bazar';

    final body = message.notification?.body ?? message.data['body'] ?? '';

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      channelDescription: 'Notifications about orders and updates',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: 'logo',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: message.data['orderId']?.toString() ?? '',
    );
  }

  // ============================================================
  // NOTIFICATION TAP
  // ============================================================

  void _onNotificationTapped(NotificationResponse response) {
    print('======================================');
    print('LOCAL NOTIFICATION CLICKED');
    print('PAYLOAD: ${response.payload}');
    print('======================================');

    if (response.payload != null && response.payload!.isNotEmpty) {
      onNotificationTap?.call({'orderId': response.payload});
    }
  }
}
