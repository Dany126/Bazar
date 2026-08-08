import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Runs in a separate isolate when app is terminated/background.
  // FCM auto-displays the system notification; nothing extra needed here
  // unless you want to persist to local storage for offline access.
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final void Function(Map<String, dynamic> data)? onNotificationTap;
  final void Function(Map<String, dynamic> data)? onForegroundMessage;

  FcmService({this.onNotificationTap, this.onForegroundMessage});

  Future<void> init() async {
    await _messaging.requestPermission();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          onNotificationTap?.call({'orderId': response.payload});
        }
      },
    );

    // Foreground: FCM does NOT auto-show a system notification, so show one manually.
    FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message.data);
      _showLocalNotification(message);
    });

    // App opened from background via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTap?.call(message.data);
    });

    // App opened from terminated state via notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onNotificationTap?.call(initialMessage.data);
    }
  }

  Future<String?> getToken() => _messaging.getToken();

  void onTokenRefresh(void Function(String token) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? message.data['title'],
      body: message.notification?.body ?? message.data['body'],
      notificationDetails: details,
      payload: message.data['orderId'],
    );
  }
}
