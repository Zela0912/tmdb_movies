class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  const NetworkException({
    this.message = 'No internet connection. Please check your network.',
  });

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  const CacheException({
    this.message = 'Local storage error. Please try again.',
  });

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException({
    this.message = 'The requested resource was not found.',
  });

  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}