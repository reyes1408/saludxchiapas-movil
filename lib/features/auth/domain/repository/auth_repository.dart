import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String identifier, String password);

  Future<Either<Failure, void>> register(Map<String, dynamic> userData);
}
