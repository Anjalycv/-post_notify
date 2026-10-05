import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_payload.dart';

abstract class NotificationRepository {
  Future<Either<Failure, bool>> requestPermission();
  Future<Either<Failure, Unit>> showNotification(NotificationPayload payload);

  Stream<NotificationPayload> get onNotificationTap;

  Future<Either<Failure, NotificationPayload?>> getLaunchNotification();
}
