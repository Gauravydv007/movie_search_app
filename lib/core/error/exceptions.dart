/// Thrown when the remote server returns an error or invalid response.
class ServerException implements Exception {
  ServerException([this.message]);
  final String? message;
}

/// Thrown when local storage (cache) fails.
class CacheException implements Exception {
  CacheException([this.message]);
  final String? message;
}

/// Thrown when device has no network connectivity.
class NetworkException implements Exception {
  NetworkException([this.message]);
  final String? message;
}
