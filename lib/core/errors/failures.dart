/// Base failure class used in the domain layer
/// Keeps the domain layer free of exception types
abstract class Failure {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class ServerFailure   extends Failure { const ServerFailure(super.message); }
class NetworkFailure  extends Failure { const NetworkFailure(super.message); }
class CacheFailure    extends Failure { const CacheFailure(super.message); }
class LocationFailure extends Failure { const LocationFailure(super.message); }
class ValidationFailure extends Failure { const ValidationFailure(super.message); }