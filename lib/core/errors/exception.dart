/// Thrown when the server returns a non-2xx response
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  @override
  String toString() => message;
}

/// Thrown when there is no internet connection
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
  @override
  String toString() => message;
}

/// Thrown when reading from local cache fails
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local storage error.']);
  @override
  String toString() => message;
}

/// Thrown when GPS location is unavailable or denied
class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => message;
}