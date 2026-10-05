import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_payload.dart';
import '../repositories/notification_repository.dart';

class ShowPostNotification implements UseCase<Unit, NotificationPayload> {
  final NotificationRepository repository;
  ShowPostNotification(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NotificationPayload payload) async {
    final permission = await repository.requestPermission();
    final granted = permission.getOrElse(() => false);
    if (!granted) return const Left(NotificationPermissionFailure());
    return repository.showNotification(payload);
  }
}
