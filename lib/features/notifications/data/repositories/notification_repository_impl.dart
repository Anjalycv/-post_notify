import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_payload.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource dataSource;
  NotificationRepositoryImpl(this.dataSource);

  @override
  Stream<NotificationPayload> get onNotificationTap => dataSource.onTap;

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      return Right(await dataSource.requestPermission());
    } catch (_) {
      return const Left(NotificationFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> showNotification(
      NotificationPayload payload) async {
    try {
      await dataSource.show(payload);
      return const Right(unit);
    } catch (_) {
      return const Left(NotificationFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationPayload?>> getLaunchNotification() async {
    try {
      return Right(await dataSource.getLaunchPayload());
    } catch (_) {
      return const Left(NotificationFailure());
    }
  }
}
