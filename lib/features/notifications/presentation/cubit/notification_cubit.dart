import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_payload.dart';
import '../../domain/usecases/show_post_notification.dart';

sealed class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationShown extends NotificationState {
  final int postId;
  const NotificationShown(this.postId);
}

class NotificationPermissionDenied extends NotificationState {
  final String message;
  const NotificationPermissionDenied(this.message);
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final ShowPostNotification _showPostNotification;

  NotificationCubit({required ShowPostNotification showPostNotification})
      : _showPostNotification = showPostNotification,
        super(const NotificationInitial());

  Future<void> notify({required int postId, required String title}) async {
    final result = await _showPostNotification(
      NotificationPayload(postId: postId, title: title),
    );
    result.fold(
      (failure) => emit(failure is NotificationPermissionFailure
          ? NotificationPermissionDenied(failure.message)
          : NotificationError(failure.message)),
      (_) => emit(NotificationShown(postId)),
    );
  }
}
