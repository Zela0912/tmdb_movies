abstract class AppFailure {
  const AppFailure({required this.message});

  final String message;
}

class ServerFailure extends AppFailure {
  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  final int? statusCode;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure({
    String message = 'No internet connection. Please check your network.',
  }) : super(message: message);
}

class CacheFailure extends AppFailure {
  const CacheFailure({
    String message = 'Local storage error. Please try again.',
  }) : super(message: message);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    String message = 'The requested resource was not found.',
  }) : super(message: message);
}