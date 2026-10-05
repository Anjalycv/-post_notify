import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/notification_payload.dart';
import '../../domain/usecases/observe_notification_taps.dart';

/// Opens the post details screen when a notification is tapped:
///  - app open / background -> listens to the tap stream
///  - app terminated        -> handles [launchPayload] after the first frame
class NotificationNavigationHandler {
  final ObserveNotificationTaps _observeTaps;
  StreamSubscription<NotificationPayload>? _subscription;

  NotificationNavigationHandler(this._observeTaps);

  void start({NotificationPayload? launchPayload}) {
    _subscription = _observeTaps().listen(_open);

    if (launchPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open(launchPayload));
    }
  }

  void _open(NotificationPayload payload) {
    AppRouter.navigatorKey.currentState
        ?.pushNamed(AppRouter.postDetails, arguments: payload.postId);
  }

  void dispose() => _subscription?.cancel();
}
