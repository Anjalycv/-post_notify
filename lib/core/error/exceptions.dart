class ServerException implements Exception {
  final int? statusCode;
  const ServerException({this.statusCode});

  String get message =>
      'Server error${statusCode != null ? ' ($statusCode)' : ''}. Please try again.';
}

class NetworkException implements Exception {
  const NetworkException();
}
