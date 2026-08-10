import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ============================================================
/// BACKGROUND FCM HANDLER
/// ============================================================
/// This function is called when Firebase receives a message while
/// the application is in the background or terminated.
///
/// IMPORTANT:
/// Keep this function top-level.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase automatically displays messages that contain
  // a "notification" payload when the app is in background.
  //
  // If your backend sends data-only notifications, you can
  // manually show a local notification here.
}

/// ============================================================
/// FCM SERVICE
/// ============================================================

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final void Function(Map<String, dynamic> data)? onNotificationTap;

  final void Function(Map<String, dynamic> data)? onForegroundMessage;

  FcmService({this.onNotificationTap, this.onForegroundMessage});

  /// ==========================================================
  /// INITIALIZE
  /// ==========================================================

  Future<void> init() async {
    // ----------------------------------------------------------
    // Request notification permission
    // ----------------------------------------------------------

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // ----------------------------------------------------------
    // Android initialization
    // ----------------------------------------------------------

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ----------------------------------------------------------
    // iOS initialization
    // ----------------------------------------------------------

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // ----------------------------------------------------------
    // General initialization
    // ----------------------------------------------------------

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;

        if (payload == null || payload.isEmpty) {
          return;
        }

        try {
          final Map<String, dynamic> data = Map<String, dynamic>.from(
            jsonDecode(payload),
          );

          onNotificationTap?.call(data);
        } catch (_) {
          // If payload isn't JSON, just pass orderId.
          onNotificationTap?.call({'orderId': payload});
        }
      },
    );

    // ----------------------------------------------------------
    // Android notification channel
    // ----------------------------------------------------------

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_updates',
      'Order Updates',
      description: 'Notifications about orders and updates',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // ----------------------------------------------------------
    // Foreground messages
    // ----------------------------------------------------------

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      onForegroundMessage?.call(message.data);

      await _showLocalNotification(message);
    });

    // ----------------------------------------------------------
    // App opened from background
    // ----------------------------------------------------------

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onNotificationTap?.call(message.data);
    });

    // ----------------------------------------------------------
    // App opened from terminated state
    // ----------------------------------------------------------

    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      onNotificationTap?.call(initialMessage.data);
    }
  }

  /// ==========================================================
  /// GET FCM TOKEN
  /// ==========================================================

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// ==========================================================
  /// LISTEN TO TOKEN REFRESH
  /// ==========================================================

  void onTokenRefresh(void Function(String token) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }

  /// ==========================================================
  /// SHOW FOREGROUND NOTIFICATION
  /// ==========================================================

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final String title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        'New Notification';

    final String body =
        message.notification?.body ?? message.data['body']?.toString() ?? '';

    final String? orderId = message.data['orderId']?.toString();

    final Map<String, dynamic> payloadData = {...message.data};

    if (orderId != null) {
      payloadData['orderId'] = orderId;
    }

    final AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
          'order_updates',
          'Order Updates',
          channelDescription: 'Notifications about orders and updates',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final String payload = jsonEncode(payloadData);

    await _localNotifications.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }
}
