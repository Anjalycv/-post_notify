import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('No internet connection. Please check your network and try again.');
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure() : super('Something went wrong. Please try again.');
}

class NotificationFailure extends Failure {
  const NotificationFailure() : super('Unable to show the notification.');
}

class NotificationPermissionFailure extends Failure {
  const NotificationPermissionFailure()
      : super('Notification permission denied. Enable it from system settings.');
}
