import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_payload.dart';
import '../repositories/notification_repository.dart';

class GetLaunchNotification
    implements UseCase<NotificationPayload?, NoParams> {
  final NotificationRepository repository;
  GetLaunchNotification(this.repository);

  @override
  Future<Either<Failure, NotificationPayload?>> call(NoParams params) =>
      repository.getLaunchNotification();
}
