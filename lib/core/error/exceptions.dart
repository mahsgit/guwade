class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server Error'});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({this.message = 'Unauthorized'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Error'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Network Error'});
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});
}

class ValidationException implements Exception {
  final String message;

  ValidationException({required this.message});
}

class FaceRecognitionException implements Exception {
  final String message;

  FaceRecognitionException({required this.message});
}
