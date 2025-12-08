import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/exceptions.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/data/datasources/symptom_remote_data_source.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/repository/symptom_repository.dart';

class SymptomRepositoryImpl implements SymptomRepository {
  final SymptomRemoteDataSource remoteDataSource;

  SymptomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AnalysisResult>> diagnose({
    required String texto,
    required String municipio,
    required String genero,
    required int edad,
    required double peso,
  }) async {
    try {
      final result = await remoteDataSource.diagnose(
        texto: texto,
        municipio: municipio,
        genero: genero,
        edad: edad,
        peso: peso,
      );
      return Right(result);
    } on ServerException {
      return const Left(
        ServerFailure('Error al conectar con el servidor de diagnóstico.'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
