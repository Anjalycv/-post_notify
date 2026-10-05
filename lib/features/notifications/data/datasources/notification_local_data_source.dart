import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/entities/notification_payload.dart';

/// All flutter_local_notifications code lives here - never in widgets.
class NotificationLocalDataSource {
  final FlutterLocalNotificationsPlugin _plugin;
  final _tapController = StreamController<NotificationPayload>.broadcast();

  NotificationLocalDataSource(this._plugin);

  static const _channel = AndroidNotificationChannel(
    'posts_channel',
    'Post notifications',
    description: 'Notifications triggered from the posts list',
    importance: Importance.high,
  );

  Stream<NotificationPayload> get onTap => _tapController.stream;

  Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings,
      // Fires when a notification is tapped while the app is open or in background.
      onDidReceiveNotificationResponse: (response) {
        final payload = NotificationPayload.tryDecode(response.payload);
        if (payload != null) _tapController.add(payload);
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Tap that launched the app from the terminated state.
  Future<NotificationPayload?> getLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return NotificationPayload.tryDecode(details!.notificationResponse?.payload);
    }
    return null;
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return true;
  }

  Future<void> show(NotificationPayload payload) {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'posts_channel',
        'Post notifications',
        channelDescription: 'Notifications triggered from the posts list',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    return _plugin.show(
      payload.postId, // one notification per post
      payload.title,
      'Post ID: ${payload.postId}',
      details,
      payload: payload.encode(),
    );
  }
}
