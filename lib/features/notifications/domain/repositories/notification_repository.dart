import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_payload.dart';

abstract class NotificationRepository {
  Future<Either<Failure, bool>> requestPermission();
  Future<Either<Failure, Unit>> showNotification(NotificationPayload payload);

  /// Taps while the app is in the foreground or background.
  Stream<NotificationPayload> get onNotificationTap;

  /// Tap that cold-started the app (terminated state).
  Future<Either<Failure, NotificationPayload?>> getLaunchNotification();
}
