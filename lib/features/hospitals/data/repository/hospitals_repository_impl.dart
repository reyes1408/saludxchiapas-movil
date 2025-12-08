import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/datasources/hospitals_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/hospitals/data/models/hospital_model.dart';
import 'package:saludxchiapas_frontend/features/hospitals/domain/repository/hospitals_repository.dart';

class HospitalsRepositoryImpl implements HospitalsRepository {
  final HospitalsRemoteDataSource remoteDataSource;

  HospitalsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<HospitalModel>>> getHospitals(
    String municipio,
  ) async {
    try {
      final result = await remoteDataSource.getHospitals(municipio);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Error al obtener hospitales'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
