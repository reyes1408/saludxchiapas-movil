// Excepción para errores del lado del servidor (API).
class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

// Excepción para errores de red.
class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message]);
}

// Excepción para errores de caché.
class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
}
