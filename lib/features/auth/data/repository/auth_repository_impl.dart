import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';
import 'package:saludxchiapas_frontend/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:saludxchiapas_frontend/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> login(
    String identifier,
    String password,
  ) async {
    try {
      final authResponse = await remoteDataSource.login(identifier, password);

      await localDataSource.cacheAuthData(authResponse);

      return Right(authResponse.token);
    } on ServerException {
      return const Left(ServerFailure('Credenciales inválidas'));
    }
  }

  @override
  Future<Either<Failure, void>> register(Map<String, dynamic> userData) async {
    try {
      await remoteDataSource.register(
        name: userData['name'],
        age: int.parse(userData['age'].toString()),
        weight: double.parse(userData['weight'].toString()),
        gender: userData['gender'],
        username: userData['username'],
        password: userData['password'],
        email: userData['email'],
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error en el registro'));
    } catch (e) {
      return const Left(ServerFailure('Error inesperado'));
    }
  }
}
