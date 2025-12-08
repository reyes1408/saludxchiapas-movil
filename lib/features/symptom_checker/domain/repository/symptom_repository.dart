import 'package:fpdart/fpdart.dart';
import 'package:saludxchiapas_frontend/core/errors/failures.dart';
// IMPORTANTE: Importamos la ENTIDAD, no el Modelo
import 'package:saludxchiapas_frontend/features/symptom_checker/domain/entities/analysis_result.dart';

abstract class SymptomRepository {
  // Fíjate aquí: Usamos AnalysisResult, NO AnalysisResultModel
  Future<Either<Failure, AnalysisResult>> diagnose({
    required String texto,
    required String municipio,
    required String genero,
    required int edad,
    required double peso,
  });
}
