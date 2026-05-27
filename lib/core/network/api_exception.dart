class ApiException implements Exception {
  final int code;
  final String message;

  ApiException({required this.code, required this.message});

  @override
  String toString() => 'ApiException($code): $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = '网络连接失败，请检查网络设置']);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = '认证失败，请重新登录']);

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final Map<String, String> errors;
  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}
