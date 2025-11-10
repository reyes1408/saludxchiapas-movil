import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Fallo general del servidor.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Fallo de red.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Fallo de caché.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Fallo genérico.
class GenericFailure extends Failure {
  const GenericFailure(super.message);
}
