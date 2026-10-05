import '../entities/notification_payload.dart';
import '../repositories/notification_repository.dart';

class ObserveNotificationTaps {
  final NotificationRepository repository;
  ObserveNotificationTaps(this.repository);

  Stream<NotificationPayload> call() => repository.onNotificationTap;
}
