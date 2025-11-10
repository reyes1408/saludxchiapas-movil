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
  Future<Either<Failure, AnalysisResult>> analyzeSymptoms(String texto) async {
    try {
      final resultModel = await remoteDataSource.analyzeSymptoms(texto);
      return Right(resultModel);
    } on ServerException {
      return Left(ServerFailure('Error al conectar con el servidor.'));
    }
    // manejar excepciones.
  }
}
